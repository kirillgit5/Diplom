#!/usr/bin/env bash

TARGET_NAME=Mooni

# Go to the script directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$DIR"

echo "Access mode:"
id -u
echo $GEM_HOME
echo $SHELL
echo $PATH
echo $CI_PIPELINE_SOURCE
echo $CI_COMMIT_BRANCH
echo $CI_COMMIT_REF_NAME
echo $CI_JOB_ID
echo $CI_PIPELINE_IID
echo $NEXUS_LOGIN
which pod
gem env

# Install Homebrew if needed
function install_homebrew {
    if hash brew 2>/dev/null; 
    then
        echo "Homebrew is installed"
    else
        echo "Homebrew is NOT installed, repair:"
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi
}

# Install Bundler if needed
if hash bundler 2>/dev/null;
then
    echo "Bundler is installed"
else
    echo "Bundler is NOT installed, repair:"
    install_homebrew

    echo "sudo gem install bundler"
    brew install bundler
fi

# Install xcodegen if needed
if hash xcodegen 2>/dev/null;
then
    echo "xcodegen is installed"
else
    echo "xcodegen is NOT installed, repair:"
    install_homebrew

    echo "brew install xcodegen"
    brew install xcodegen
fi

# Install ruby dependencies
echo "bundle install --verbose"
bundle install --verbose

# Update Fastlane plugins
bundle exec fastlane update_plugins

sh pod_install.command