#!/bin/bash

function printAndExecute {
    echo "\$ ${1}"
    eval "$1" &> /dev/null
    if [ $? -ne 0 ]; then
        echo -e "\e[31mFailed: command exited with status ${?}\e[0m"
    fi
}

printAndExecute "sudo apt update"
printAndExecute "sudo apt upgrade -y"
printAndExecute "sudo apt autoremove -y"
echo -e "\e[34mDone\e[0m"

