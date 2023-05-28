#!/usr/bin/env bash

TARGET_NAME=Mooni

# Check xcodegen is installed
if hash xcodegen 2>/dev/null;
then
    echo "xcodegen is installed"
else
    echo "xcodegen is not installed, run setup.sh"
fi

# Go to the script directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" 
cd "$DIR"

# Make directories for SwiftGen results
function mkdir_touch {
  mkdir -p "$(dirname "$1")"
  command touch "$1"
}

xcodegen generate