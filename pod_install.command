#!/usr/bin/env bash

TARGET_NAME=DiplomProjet

# Go to the script directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" 
cd "$DIR"

# Generate xc-files by xcodegen
sh xcodegen.command

# Найдем директорию, в которой лежит файл исполняемого скрипта
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" 

# Перейдем в нее
cd "$DIR"

# Проверка установки Bundler
if hash bundler 2>/dev/null; 
then
    echo Bundler is installed
else    
    echo Bundler is not installed, run setup.command
    exit 1
fi

# Создаем generated файлы
function mkdir_touch {
  mkdir -p "$(dirname "$1")"
  command touch "$1"
}

# Генерируем проект
sh xcodegen.command

# Подгрузим поды
bundle exec pod install