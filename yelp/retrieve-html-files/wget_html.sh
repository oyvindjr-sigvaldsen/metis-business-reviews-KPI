#!/bin/bash
# requires jq homebrew module to read and parse .json
# requires wget for sending http-requests

# english wget log command : export LANG=en_GB.UTF-8

# clear business-html-files dir
cd ..; rm *.html; cd modules;
num_businesses= jq ".business_urls | length" business_urls.json;

typeset -i i END
let END=9 i=0

while ((i<=END)); do

	max_sleep=60
	random_sleep=$(shuf -i 1-$max_sleep -n 1);
	random_proxy=$(shuf -n 1 proxy_list.txt);

	source ./progress-bar.sh;
	echo "random_sleep : "$random_sleep" seconds";
	progress-bar $random_sleep;

	cluster=(
				$(jq -r ".business_urls[$i] .business_name" business_urls.json)
				$(jq -r ".business_urls[$i] .url" business_urls.json)
			);

	url=${cluster[1]};

	try=$(wget -e use_proxy=yes http_proxy=$random_proxy --output-document="../${cluster[0]}.html" $url);
	fail=$(wget --output-document="../${cluster[0]}.html" $url);

	$try || $fail;
	let i++;
done

# TODO: update wget_html.sh to same file found on the tripadvisor-webscraper branch
# TODO: merge business_urls.json from yelp and tripadvisor branches and move to global dir scope
# TODO: move single proxy_list.txt to global scope, same folder as business_urls.json (merged version)
# TODO: move single progress-bar.sh to global scope, same folder as business_Urls.json and proxy_list.txt
