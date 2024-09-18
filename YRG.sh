#!/usr/bin/env bash
#__   ______   ____ 
#\ \ / /  _ \ / ___|
# \ V /| |_) | |  _ 
#  | | |  _ <| |_| |
#  |_| |_| \_\\____|
#
# Youtube RSS Generator
# A simple bash script to generate RSS urs for a particular youtube channel from its handle
# example usage: ./YRG.sh https://www.youtube.com/@handle
#

url="$1"
filtercmd="sed -n 's/.*\(https:\/\/www\.youtube\.com\/channel\/[a-zA-Z0-9_-]\{24\}\).*/\1/p' | sort | uniq"

# Define the filter function
function filter(){
  local url="$1"
  if [[ -z "$url" ]]; then
    echo "Usage: filter <url>"
    return 1
  fi
  curl -s "$url" | eval "$filtercmd"
}

filtered_output=$(filter "$url")

channel_id="${filtered_output#*channel/}"
converted_url="https://www.youtube.com/feeds/videos.xml?channel_id=$channel_id"
echo -e "Link with id: $filtered_output"
echo -e "RSS URL: $converted_url"
