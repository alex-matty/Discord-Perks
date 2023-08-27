#!/bin/bash

# A script used to gather information from news sources and post them as a message via discord webhooks
# Currently it is configured to get information from thehackernews.com and bleepingcomputer.com
# Created by MEGANUKE

# Delete old  hackernews json files if exist so we can start fesh
if [[ -f hackernews.json ]]
then
	rm -rf hackernews.json
fi

if [[ -f hackernews.json.dirty ]]
then
	rm -rf hackernews.json.dirty
fi

# Create a new empty file to append the content (This might be redundant)
touch hackernews.json
touch hackernews.json.dirty

# Add the first part of the json forging it to get the correct syntax (Find a way to improve json files)
echo "{ \"content\": \"https://www.thehackernews.com" > hackernews.json.dirty

# Retrieve news (only headers) from The Hacker News
curl -s https://thehackernews.com/ | grep -o "<h2 class='home-title'>.*<\/h2>" | sed 's/<img.*//g' | sed "s/<h2\ class='home-title'>//g" | sed "s/<.*//g" | sed '/^$/d' | sed 's/"/\\"/g' >> hackernews.json.dirty

# Transform the content of the file into correct json syntax
cat hackernews.json.dirty | sed -z 's/\n/\\n/g' | sed 's/\\n$/\" }/g' >> hackernews.json

# Send the content of the corrected and complete json file to discord via webhook address.
curl -X POST -H "Content-Type: application/json" -d @hackernews.json https://discord.com/api/webhooks/REDACTED

# Delete bleeping computer old files if exist so we can start fesh
if [[ -f bleepingcomputer.json ]]
then
	rm -rf bleepingcomputer.json
fi

if [[ -f bleepingcomputer.json.dirty ]]
then
	rm -rf bleepingcomputer.json.dirty
fi

# Create a new empty bleeping computer file to append the content (This again might be redundant)
touch bleepingcomputer.json
touch bleepingcomputer.json.dirty

# Add the first part of the json to bleeping computer json file
echo "{ \"content\": \"https://www.bleepingcomputer.com/" > bleepingcomputer.json.dirty

# Download an clean content from bleepingcomputer.com (retrieve the news headers)
curl -s https://www.bleepingcomputer.com/ | grep '<h4>.*<\/h4>' | awk '!/<h4><a href="https:\/\/www\.bleepingcomputer\.com\/news\/security\//{$0=""}1' | sed '/^$/d' | sed 's/<h4.*">//g' | sed 's/<\/a.*//g' | sed 's/"/\\"/g' >> bleepingcomputer.json.dirty

# Transform the content of the file into a valid json file
cat bleepingcomputer.json.dirty | sed -z 's/\n/\\n/g' | sed 's/\\n$/\" }/g' >> bleepingcomputer.json

# Send the content of the json to discord webhook address.
curl -X POST -H "Content-Type: application/json" -d @bleepingcomputer.json https://discord.com/api/webhooks/REDACTED