#!/bin/bash

if [ ${PWD##*/} != "jbscripts" ]; then
    echo "Please run this script from jbscripts directory"
    exit
fi

echo '~/.bashrc file will be modified to add jbscripts to the PATH, do you want to continue (y/n)?'
read answer

if [ "$answer" != "y" ] ; then
    exit
fi

if [ $(grep -ic "jbscripts" ~/.bashrc) -gt 0 ]; then
    echo .bashrc already contains "jbscripts"
    echo Please add manually the following line at the end .bashrc file: PATH=\$PATH:~/${PWD##*/}
    exit
fi

if [ ! -w ~/.bashrc ]; then
    echo Cannot modify .bashrc
    echo Please add the following line at the end .bashrc file: PATH=\$PATH:~/${PWD##*/}
    echo or add jbscripts to your PATH in other way
    exit
fi

echo PATH=\$PATH:~/${PWD##*/} | tee -a ~/.bashrc

echo ~/.bashrc file have been modified