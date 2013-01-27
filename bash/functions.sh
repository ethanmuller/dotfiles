stty -ixon -ixoff # fix for <C-s> in terminal Vim

function take {
    mkdir $1
      cd $1
}
function hg {
  history | grep --color=auto $1
}
function tell {
    cd $1
      ls -l
}
function rvm_install {
    rvm install $1 --with-gcc=clang
}
function migrate {
    rake db:migrate
      rake db:test:prepare
}
function parse_git_branch {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ \[\1\]/'
}
function esc {
  local START='\['
  local END='\]'
  __esc_string=$START$1$END
  echo "$__esc_string"
}
function init {
  local RED="\033[0;31m"
  local NC="\033[0m"

  if [ ! $# == 1 ]; then
    echo -e "${RED}Please specify a project name.${NC}"
    echo -e "Usage: init project-name\n"
  else
    if ! type "ruby" > /dev/null; then
      echo -e "${RED}Please install Ruby:${NC}"
      echo "http://www.ruby-lang.org/en/downloads/"
    else
      if ! type "npm" > /dev/null; then
        echo -e "${RED}Please install Node:${NC}"
        echo "http://nodejs.org/download/"
      else
        if ! type "grunt" > /dev/null; then
          echo -e "${RED}Please install grunt-cli:${NC}"
          echo "npm install grunt-cli"
        else
          echo -e "${RED}Downloading project-init${NC} 🚀\n"
          curl -s -S -O -L http://github.com/sparkbox/project-init/archive/master.zip;
          echo -e "${RED}Download finished.${NC}\n"
          echo -e "${RED}Setting up project config files.${NC}\n"
          unzip -qq master.zip;
          rm master.zip;
          mv project-init-master $1
          sed -i.bak "s/Project-Name/$1/g" $1/package.json;
          rm $1/package.json.bak;
          sed -i.bak "s/Project-Name/$1/g" $1/.rvmrc;
          rm $1/.rvmrc.bak;
          cd $1
          npm install;
          bundle;
          echo -e "${RED}Your project is all ready to go. Enjoy${NC}\n"
        fi
      fi
    fi
  fi
}
function pretty_prompt {

  local    DEFAULT="\e[0m"
  local	   BLACK="\e[30m"
  local	   RED="\e[31m"
  local    GREEN="\e[32m"
  local    YELLOW="\e[33m"
  local    BLUE="\e[34m"
  local    MAGENTA="\e[35m"
  local	   CYAN="\e[36m"
  local    WHITE="\e[37m"
  local    CHAR="\xE2\x98\xA0"

PS1="$(esc $CYAN)"
PS1+="\u " # print user
PS1+="$(esc $WHITE)"
PS1+="\w " # print working directory
PS1+="$(esc $BLUE)"
PS1+="\$(parse_git_branch)" # print current git branch
PS1+="\n" # print newline
PS1+="$(esc $YELLOW)"
PS1+="➜ " # cutesy prompt character
PS1+="$(esc $DEFAULT)"

}
pretty_prompt
