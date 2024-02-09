#!/bin/bash   
 
if [ -z "$SCRIPT_DIR" ]
then
#Find script original dir even if called with a symlink
export SCRIPT_DIR="$( cd "$( dirname "$(readlink -f "${BASH_SOURCE[0]}" )" )" && pwd )"
#
fi

# Retrieve the active hrev value using uname -a
# how do I find the r1~beta4_ string from the current install ?
clear
nblines=20
basever='r1~beta4_'
active_build=$basever$(uname -a | grep -o 'hrev[0-9]*' )

uname_output=$(uname -a)
if [[ $uname_output == *x86_64* ]]; then
   url="https://eu.hpkg.haiku-os.org/haiku/master/x86_64"
elif [[ $uname_output == *x86_gcc2* ]]; then
   url="https://eu.hpkg.haiku-os.org/haiku/master/x86_gcc2"
else
    echo "Unsupported architecture, please fix the script to support this"
    exit 1
fi


echo "----------------------------"
echo "Active build: $active_build"
echo "----------------------------"

echo "Fetching versions from:"
echo $url 

# Fetch the content from the URL and extract the 10 most recent version numbers
content=$(curl --connect-timeout 20 -s $url)
if [ -z "$content" ]; then
   echo "Ooops - server responded with empty string. Maybe a timeout"
   exit 1 
fi

versions=$(echo "$content" | grep -a -o '"r1~beta[0-9]_hrev[0-9]*"' | sed 's/"//g' | sort -r | head -n $nblines)

versions="current"$'\n'"$versions"

IFS=$'\n' read -r -d '' -a versions_array <<< "$versions"

selected_index=0
while true; do
    clear
    echo "----------------------------"
    echo "Pick the Haiku Revision to install"
    echo "Only 'current' will enable future updates"
    echo "----------------------------"
    echo 
    # Display the version numbers with index
    for i in "${!versions_array[@]}"; do
        if [ "${versions_array[i]}" == "$active_build" ]; then

           if [ $i -eq $selected_index ]; then
	       echo "> ${versions_array[i]} (Installed)"
            else
	       echo "  ${versions_array[i]} (Installed)"
            fi
        elif [ $i -eq $selected_index ]; then
            echo "> ${versions_array[i]}"
        else
            echo "  ${versions_array[i]}"
        fi
    done

    read -rsn1 input

    case "$input" in
        "A") # Up arrow key
            selected_index=$((selected_index - 1))
            ;;
        "B") # Down arrow key
            selected_index=$((selected_index + 1))
            ;;
        "") # Enter key
            selected_version="${versions_array[selected_index]}"
            break
            ;;
    esac

    # Check bounds limits
    if [ $selected_index -lt 0 ]; then
        selected_index=0
    elif [ $selected_index -ge ${#versions_array[@]} ]; then
        selected_index=$(( ${#versions_array[@]} - 1 ))
    fi
done

# Extract the part after "hrev" and print it
hrev=$(echo "$selected_version" | sed 's/.*hrev//')

if [ "$hrev" != "current" ]; then
tag=hrev$hrev
source $SCRIPT_DIR/haikuchanges.sh
fi

# Prompt user to launch next command
read -p "Do you want to proceed installing Haiku revision $hrev (y/n): " choice
echo
if [[ $choice == "y" || $choice == "Y" ]]; then
    echo "----------------------------"
    echo "Installing revision: $hrev"
    echo "----------------------------"
    
    if [ "$hrev" = "current" ]; then
       
       upurl="https://eu.hpkg.haiku-os.org/haiku/master/$(getarch)/current"
    else

       upurl="https://eu.hpkg.haiku-os.org/haiku/master/$(getarch)/$basever"hrev"$hrev"
    
    fi

    pkgman add $upurl
    pkgman full-sync
    echo 
    echo "----------------------------"
    read -p "Do you want to reboot now ? (y/n)" choice
    echo "----------------------------"
    echo
    if [[ $choice == "y" || $choice == "Y" ]]; then
      echo "Rebooting now..."
      shutdown -r  -s 
    else
      echo "Ok. But one day you will have to reboot. We all do."
    fi

else
    echo "Exiting..."
fi
