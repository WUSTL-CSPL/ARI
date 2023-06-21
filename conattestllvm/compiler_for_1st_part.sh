#!/bin/bash

# Specify the source and target files
source_file1="./CFEventsPass_disable"
target_file1="./lib/Target/ARM/CFEventsPass.cpp"

source_file2="./SFIPass_disable"
target_file2="./lib/Target/ARM/SFIPass.cpp"

# Define a function to replace the contents of one file with another
replace_contents() {
    local source_file="$1"
    local target_file="$2"

    # Make sure source_file exists and is a regular file
    if [ ! -f "$source_file" ]; then
        echo "Source file ($source_file) does not exist or is not a regular file."
        exit 1
    fi

    # Replace contents of target file with source file
    cat "$source_file" > "$target_file"

    echo "Contents of $target_file have been replaced with contents of $source_file."
}

# Call the function for both pairs of files
replace_contents "$source_file1" "$target_file1"
replace_contents "$source_file2" "$target_file2"
