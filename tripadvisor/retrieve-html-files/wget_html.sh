#!/bin/bash
# requires jq homebrew module to read and parse .json
# requires wget for sending http-requests

# english wget log command : export LANG=en_GB.UTF-8

# clear business-html-files dir
cd html-files; rm *.html; cd ..;
num_businesses=$(jq ".business_urls | length" data-files/business_urls.json);

echo $num_businesses;

typeset -i i END
let END=$num_businesses i=0;

while ((i<=END-1)); do

	max_sleep=60
	random_sleep=$(shuf -i 1-$max_sleep -n 1);
	random_proxy=$(shuf -n 1 data-files/proxy_list.txt);

	source ./progress-bar.sh;
	echo "random_sleep : "$random_sleep" seconds";
	progress-bar $random_sleep;

	cluster=(
				$(jq -r ".business_urls[$i] .business_name" data-files/business_urls.json)
				$(jq -r ".business_urls[$i] .url" data-files/business_urls.json)
			);

	url=${cluster[1]};
	$(wget -e use_proxy=yes http_proxy=$random_proxy --output-document="html-files/${cluster[0]}.html" $url); true || $(wget --output-document="html-files/${cluster[0]}.html" $url);

	let i++;
done
