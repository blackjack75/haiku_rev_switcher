#!/bin/bash

link="/boot/home/config/non-packaged/bin/haikurev"
target=$(realpath "./haikurev.sh")

if [ -L "$link" ]; then
    echo "Symbolic link already exists."
    read -p "Do you want to overwrite it? (y/n): " overwrite
    echo
    if [ "$overwrite" == "y" ]; then
        ln -sf "$target" "$link"
        echo "Symbolic link overwritten."
    else
        echo "Operation cancelled."
    fi
else
    ln -s "$target" "$link"
    
    echo "Symbolic link created."
fi
echo
echo "You can now run haikudev from anywhere"
