#!/bin/bash
if [ -z "$tag" ]; then
        echo "tag variable not defined when called directly, using hardcoded test tag"
	tag="hrev57573"
	echo
	echo
fi
if [ -n "$HAIKU_SRC" ]; then

cd $HAIKU_SRC

echo "Commit messages for tag $tag :"
echo
git log --oneline --decorate |  grep $tag | sed 's/([^)]*)//' | cut -d' ' -f2-
echo

else
	echo "(you need to define $HAIKU_SRC to see commit messages for this tag)"
fi
