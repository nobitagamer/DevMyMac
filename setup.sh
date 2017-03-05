#!/bin/sh

# Color Variables
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

HOME_DIR="$HOME"

# Ask for the administrator password upfront.
sudo -v

# Keep Sudo Until Script is finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Check if OSX Command line tools are installed
if type xcode-select >&- && xpath=$( xcode-select --print-path ) &&
    test -d "${xpath}" && test -x "${xpath}" ; then
    ###############################################################################
    # Computer Settings                                                           #
    ###############################################################################
    echo -e "${RED}Enter your computer name please?${NC}"
    read cpname
    echo -e "${RED}Please enter your name?${NC}"
    read name
    echo -e "${RED}Please enter your git email?${NC}"
    read email

    clear

    sudo scutil --set ComputerName "$cpname"
    sudo scutil --set HostName "$cpname"
    sudo scutil --set LocalHostName "$cpname"
    defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$cpname"

    defaults write -g ApplePressAndHoldEnabled -bool false
    defaults write com.apple.finder ShowPathbar -bool true
    defaults write com.apple.finder ShowStatusBar -bool true
    defaults write NSGlobalDomain KeyRepeat -int 0.02
    defaults write NSGlobalDomain InitialKeyRepeat -int 12
    chflags nohidden ~/Library


    git config --global user.name "$name"

    git config --global user.email "$email"

    git config --global color.ui true

    ###############################################################################
    # Install Applications                                                        #
    ###############################################################################

    # Install Homebrew
    echo "Installing Homebrew"
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"


    clear
    echo -e "${RED}Install NodeJS? ${NC}[y/N]"
    read -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
      # Install Nodejs
      echo "Installing NVM"
      curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.4/install.sh | bash

      export NVM_DIR="$HOME_DIR/.nvm"
      [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm so we dont have to reboot the terminal

      #Installing Nodejs

      echo "Installing Nodejs"
      nvm install node
      nvm use node

    fi

    clear
    echo -e "${RED}Install Python? ${NC}[y/N]"
    read -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
      # Install Python
      brew install python
    fi

    clear
    echo -e "${RED}Install Ruby?${NC} [y/N]"
    read -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
      # Install ruby
      brew install gpg
      command curl -sSL https://rvm.io/mpapis.asc | gpg --import -
      \curl -L https://get.rvm.io | bash -s stable
      source ~/.rvm/scripts/rvm
      rvm install ruby-2.3.1

      gem install bundler
      gem install rails
    fi

    clear
    echo -e "${RED}Setup for Java Development? ${NC}[y/N]"
    read -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
      brew cask install \
      java \
      eclipse-ide \
      eclipse-java
    fi

    clear
    echo -e "${RED}Setup For Android Developemnt?${NC} [y/N]"
    read -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
      brew cask install \
      java \
      eclipse-ide \
      eclipse-java \
      android-studio \
      intellij-idea-ce

      brew install android-sdk
    fi
    
    clear
    echo -e "${RED}Setup for rust (via rustup)? ${NC}[y/N]"
    read -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        curl https://sh.rustup.rs -sSf | sh
    fi

    clear
    echo -e "${RED}Install Databases? ${NC}[y/N]"
    read -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
      brew install mysql
      brew install postgresql
      brew install mongo
      brew install redis
      brew install elasticsearch

      # Install mysql workbench
      # Install Cask
      brew install caskroom/cask/brew-cask
      brew cask install --appdir="/Applications" mysqlworkbench
    fi

    clear
    # Install zsh
    echo "Installing ZSH"
    brew install zsh zsh-completions
    chsh -s $(which zsh)
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    curl https://gist.githubusercontent.com/Gram21/35dc66c4673bb63fa8c1/raw/.zshrc > ~/.zshrc


    clear
    # Install Homebrew Apps
    echo "Installing Homebrew Command Line Tools"
    brew install \
    tree \
    wget \
    m-cli \
    docker
    
    brew tap caskroom/cask

    echo "Installing Apps"
    brew cask install \
    google-chrome \
    firefox \
    thunderbird \
    iterm2 \
    sublime-text \
    mactex \
    visual-studio-code \
    virtualbox \
    vlc \
    dropbox \
    alfred \
    wireshark \
    vagrant \
    quassel-client
    

    echo "Cleaning Up Cask Files"
    brew cask cleanup

    clear

else
   echo "Need to install the OSX Command Line Tools (or XCode) First! Starting Install..."
   # Install XCODE Command Line Tools
   xcode-select --install
fi
