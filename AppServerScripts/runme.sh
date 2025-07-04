#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Input Directory Required as Argument"
    exit 1
fi

# Get the filename from the first argument
inpDirectory="$1"
AWKBINARY="./awkscript.awk"
count="0"
# Check if the file exists
if [ ! -d "$inpDirectory" ]; then
    echo "Input Directory '$inpDirectory' does not exist."
    exit 1
fi

for filename in "$inpDirectory"/*; do

    if [ -f "$filename" ]; then
        echo "File is:"$filename
        ${AWKBINARY} ${filename} 
            if [[ $? -ne 0 ]]; then
                echo "Failed to Process File  : $filename"
            else
                echo "Processing Done on File : $filename"
            fi
    fi
done
