#!/bin/bash
# requires jq homebrew module to read and parse .json
# requires wget for sending http-requests

# clear business-html-files dir
cd ..; rm *.html; cd modules;

num_businesses= jq ". | length" business_urls.json;

for i in $(seq 0 $num_businesses); do

	cluster=(
				$(jq -r ".business_urls[$i] .business_name" business_urls.json)
				$(jq -r ".business_urls[$i] .url" business_urls.json)
			);

	url=${cluster[1]};

	wget --output-document="../${cluster[0]}.html" $url;
done
