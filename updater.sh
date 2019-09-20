#!/bin/bash

URL=https://xteve.de/download/xteve_linux
REGEX='Content-Length: ([0-9]+)'
REGEX_VERSION='Version: +([\.0-9]+)'
XTEVE_FILENAME=xteve_linux

output=$(curl -k -L --head --fail -s $URL | grep Content-Length)

[[ $output =~ $REGEX ]]
content_length=${BASH_REMATCH[1]}
if [[ -z $content_length ]]; then
	echo "Getting xteve_linux headers failed"
	echo $output
	exit 1;
fi

if [[ -a last_content_length ]]; then
	if [[ $content_length != $(cat last_content_length) ]]; then
		echo "Updating repo"
		curl -L --fail -s $URL -O $XTEVE_FILENAME
		chmod +x $XTEVE_FILENAME
		output=$(timeout 1 ./$XTEVE_FILENAME 2>&1)
		[[ $output =~ $REGEX_VERSION ]]
		version=${BASH_REMATCH[1]}
		version_tag=v$version
		if [[ -z ${BASH_REMATCH[1]} ]]; then
			echo "Fail: $output \n Version: $version"
			exit 2;
		fi
		date=$(date +"%Y-%m-%d_%H:%M:%S")
		sed -i -e 's/VERSION=.*/VERSION='"$version"'/g' Dockerfile
		sed -i -e 's/COMMIT_DATE=.*/COMMIT_DATE='"$date"'/g' Dockerfile
		git add Dockerfile
		git commit -m "xTeve version $version" > /dev/null
		if [[ `git tag -l $version_tag` == $version_tag ]]; then
    		git push --delete origin $version_tag > /dev/null
			git tag -d $version_tag > /dev/null
		fi
		git tag $version_tag > /dev/null
		git push --tags origin > /dev/null
		git push origin > /dev/null
		rm $XTEVE_FILENAME
	fi
fi

echo -n $content_length > last_content_length


