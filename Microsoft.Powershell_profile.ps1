#################################
##       Shell Utilites
#################################
function reload {
    & $profile
}

Set-Alias -Name rel -Value reload

# bd === "cd -"
[System.Collections.Stack]$GLOBAL:dirStack = @()
$GLOBAL:oldDir = ''
$GLOBAL:addToStack = $true
function prompt
{
    Write-Host "PS $(get-location)>"  -NoNewLine -foregroundcolor Magenta
    $GLOBAL:nowPath = (Get-Location).Path
    if(($nowPath -ne $oldDir) -AND $GLOBAL:addToStack){
        $GLOBAL:dirStack.Push($oldDir)
        $GLOBAL:oldDir = $nowPath
    }
    $GLOBAL:AddToStack = $true
    return ' '
}
function BackOneDir{
    $lastDir = $GLOBAL:dirStack.Pop()
    $GLOBAL:addToStack = $false
    cd $lastDir
}
Set-Alias bd BackOneDir

# bash like autocomplete on Tab
Set-PSReadlineKeyHandler -Key Tab -Function Complete

function pro {
	param(
	[switch] $np
	)
	$path = "$PSScriptRoot\Microsoft.Powershell_profile.ps1"
	if ($np) {
		start notepad++ $path
	}
	else {
		vim $path
	}
}

#################################
##     Dev Utilities
#################################
function q { python $args }
function gs { git status }
function gd { git diff }
function gb { git branch }

function groot {
    # cd to git root
    # taken from: https://stackoverflow.com/a/957978
	cd (git rev-parse --show-toplevel)
}

function ag {
    # usage: ag foo bar car
    findstr /spin /c:"$args" *
}

function nixPath {
    # convert windows path to linux path
	param($winpath)
	# src: https://stackoverflow.com/a/34286537
	return (($winpath -replace "\\","/") -replace ":","").Trim("/")
}

function tig {
    $argument = $($args -join " ")
    # argument paths need to be converted to
    # linux paths
	$argument = nixPath $argument
    bash -c "tig $argument"
}

function faves {
	# print list of favorite_dirs, like [0] pa/th [0]
    # usage: faves                    # lists
    #        faves -jmp 0 | faves 0   # jump to 0th dir

	# TODO: the list of fave dirs could be dynamically updated
	# either by parsing PS history file
	# or explicitly tracking directory changes
	# keep track of last N histories visited

	param(
	[string] $jmp = $null,
	[switch] $help = $false
	)

	# list of favorite dirs
	$favedirs = @(
		"C:\",
        "C:\Users\spandan",
	)


	if (![string]::IsNullOrEmpty($jmp)) {
		write-output "jumping to $jmp"
		cd $favedirs[$jmp]
	}
	elseif ($help){
			write-output "Usage: faves [-help | -jmp num] (no-arg lists faves)"
	}
	else{
		# output the dirs
		for($i = 0; $i -le $favedirs.count -1; $i++) {
			$dir = $favedirs[$i]
			write-output "[$i]:  $dir [$i]"
		}
	}
}
