#!/bin/bash

# Ensure the script is run with sudo
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as sudo. Please restart it with 'sudo'."
    exit 1
fi

# Install oletools
if [[ ! -d "oletools" ]]; then
    echo "Cloning the oletools repository..."
    git clone https://github.com/decalage2/oletools.git
    cd oletools || exit
    sudo -H python3 setup.py install
    cd oletools
else
    echo "oletools repository already exists. Skipping download."
    cd oletools
fi

# Prompt user for file input
echo "Please enter the file name + path here: "
read -r file
if [[ ! -f $file ]]; then
    echo "File not found! Please provide a valid file path."
    exit 1
fi

# Set output file path
output_file="../macro_checker.txt"
echo "" > "$output_file"  # Clear the file before writing

# User interaction prompt
while true; do
    echo ""  # Newline for readability
    echo -e "\033[1;31m##############################################\033[0m"
    echo -e "\033[1;31mWelcome to Macro Automation Check by Avior Mostovski\033[0m"
    echo -e "\033[1;31m##############################################\033[0m"
    echo -e "\033[1;32m"
    echo "       ███╗   ███╗ █████╗ ██╗     ██╗    ██╗ █████╗ ██████╗ ███████╗"
    echo "       ████╗ ████║██╔══██╗██║     ██║    ██║██╔══██╗██╔══██╗██╔════╝"
    echo "       ██╔████╔██║███████║██║     ██║ █╗ ██║███████║██████╔╝███████╗"
    echo "       ██║╚██╔╝██║██╔══██║██║     ██║███╗██║██╔══██║██╔═══╝ ╚════██║"
    echo "       ██║ ╚═╝ ██║██║  ██║███████╗╚███╔███╔╝██║  ██║██║     ███████║"
    echo "       ╚═╝     ╚═╝╚═╝  ╚═╝╚══════╝ ╚══╝╚══╝ ╚═╝  ╚═╝╚═╝     ╚══════╝"
    echo -e "\033[0m"
    echo "Choose the option you want:"
    echo "1. Check file info"
    echo "2. Check for macros"
    echo "3. Display macro code"
    echo "4. Exit"
    read -rp "Enter your choice (1/2/3/4): " choice

    case $choice in
        1)
            echo "File Info:" >> "$output_file"
            echo "Running oleid and ftguess..."
            python3 oletools/oleid.py "$file" | tee -a "$output_file"
            python3 oletools/ftguess.py "$file" | tee -a "$output_file"
            echo "Output saved to $output_file."
            ;;

        2)
            echo "Macro Checker:" >> "$output_file"
            echo "Running mraptor3 and olevba..."
            python3 oletools/mraptor3.py "$file" | tee -a "$output_file"
            python3 oletools/olevba.py -a --relaxed "$file" | tee -a "$output_file"
            echo "Output saved to $output_file."
            ;;

        3)
            echo "Decoded Macro:" >> "$output_file"
            echo "Running olevba to decode macro..."
            python3 oletools/olevba.py --decode --relaxed "$file" | tee -a "$output_file"
            echo "Output saved to $output_file."
            ;;

        4)
            echo "Exiting. Thank you for using macro automation check by Avior Mostovski."
            exit 0
            ;;

        *)
            echo "Invalid choice. Please select 1, 2, 3, or 4."
            ;;
    esac

done

# All rights reserved to python-oletools by Philippe Lagadec.
# This is just an automation tool, made by Avior Mostovski.
