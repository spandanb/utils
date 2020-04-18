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
Set-Alias -Name "ag" -Value "findstr"

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
