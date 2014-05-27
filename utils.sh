#!/bin/bash

#Create bash_aliases file
bash_aliases="~/.bash_aliases"
if [ -f $bash_aliases ]; then
    . $bash_aliases
else
    echo "Creating $bash_aliases"
    touch $bash_aliases
fi

#Create git completion file 
if [ ! -f ~/.git-completion.bash ]; then
    cd ~
    wget -O ~/.git-completion.bash https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
fi

#Overwrites any existing $bash_aliases file
cat > $bash_aliases << "EOF"
#!/bin/bash

alias reload="source ~/.bashrc"
alias profile="vim ~/.bash_aliases"

#git helper aliases
alias gr="git remote -v" #List
alias gf="git fetch"
alias gb="git branch -a"
alias gc="git checkout s-havana"
EOF

#reload bashrc file
source ~/.bashrc


# cd ~ && wget https://raw.githubusercontent.com/spandanb/utils/master/utils.sh && chmod +x utils.sh && ./utils.sh && rm ~/utils.sh