#!/bin/bash

THIS_SCRIPT_DIR_PATH=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
THIS_SCRIPT_DIR=$( basename ${THIS_SCRIPT_DIR_PATH} )

echo "~/.bashrc file will be modified to add ${THIS_SCRIPT_DIR_PATH} to the PATH, do you want to continue (y/n)?"
read answer

if [ "$answer" != "y" ] ; then
    :
elif [ $(grep -ic "${THIS_SCRIPT_DIR}" ~/.bashrc) -gt 0 ]; then
    echo .bashrc already contains "${THIS_SCRIPT_DIR}"
    echo Please add following line at the end of .bashrc file:
    echo PATH=\$PATH:${THIS_SCRIPT_DIR_PATH}
elif [ ! -w ~/.bashrc ]; then
    echo Cannot modify .bashrc
    echo Please add following line at the end of .bashrc file:
    echo PATH=\$PATH:${THIS_SCRIPT_DIR_PATH}
    echo or add ${THIS_SCRIPT_DIR_PATH} to your PATH in other way
else
    echo PATH=\$PATH:${THIS_SCRIPT_DIR_PATH} | tee -a ~/.bashrc
    echo ~/.bashrc file have been modified
    echo running source ~/.bashrc
    source ~/.bashrc
fi
