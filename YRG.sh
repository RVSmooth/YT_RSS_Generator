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

#Some colors
RESET='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'

# Color Functions

ERED() {
    echo -e "${RED}$@${RESET}"
}

EGREEN() {
    echo -e "${GREEN}$@${RESET}"
}

EYELL() {
    echo -e "${YELLOW}$@${RESET}"
}

EBLUE() {
    echo -e "${BLUE}$@${RESET}"
}

filtercmd="sed -n 's/.*\(https:\/\/www\.youtube\.com\/channel\/[a-zA-Z0-9_-]\{24\}\).*/\1/p' | sort | uniq"

# Define the filter function
function filter(){
  if [[ -z "$url" ]]; then
    echo "Usage: filter <url>"
    return 1
  fi
  curl -s "$url" | eval "$filtercmd"
}


function filter_it(){

filtered_output=$(filter "$url")
channel_id="${filtered_output#*channel/}"
converted_url="https://www.youtube.com/feeds/videos.xml?channel_id=$channel_id"

EGREEN URL WITH ID:
echo -e $filtered_output
EBLUE RSS URL: 
echo -e $converted_url
echo

}

for handles in "$@"; do
	channel_name="$( echo $handles | awk -F '@' '{print $2}')"
	url="$( echo $handles | awk -F '@' '{print "@"$2}' | awk -F '/' '{print "https://www.youtube.com/"$1}')"
	EYELL CHANNEL: $channel_name
	filter_it
done


