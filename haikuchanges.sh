#!/bin/bash
if [ -z "$tag" ]; then
        echo "tag variable not defined when called directly, using hardcoded test tag"
	tag="hrev57573"
	echo
	echo
fi

if [ -n "$HAIKU_SRC" ]; then
   echo
   echo "You have Haiku Sources installed"
   echo "in $HAIKU_SRC"
   read -p "check for remote  changes (y/n) " response
   echo
   
 if [[ $response =~ ^[Yy]$ ]]; then
   cd $HAIKU_SRC

   echo "Fetching state for \$HAIKU_SRC"

   git fetch

   if [ $(git rev-parse HEAD) != $(git rev-parse @{u}) ]; then
     echo "!! HAIKU-SRC - your branch is behind the remote repository."
     read -p "Pull latest changes? (y/n) " response
     echo
     if [[ $response =~ ^[Yy]$ ]]; then
        git pull
     else
        echo "Okay, doing nothing. You may not see recent commit messages if $tag is recent."
     fi
   else
       echo "OK - Haiku source is up to date with remote"
   fi
else

        echo "Okay, doing nothing. You may not see recent commit messages if $tag is recent."

fi


echo "Commit messages for tag $tag :"
echo
git log --oneline --decorate |  grep $tag | sed 's/([^)]*)//' | cut -d' ' -f2-
echo

else
	echo "(you need to define $HAIKU_SRC to see commit messages for this tag)"
fi
