#!/bin/bash

# clear json-files dir
cd files; rm *.json; cd ..;

num_businesses=$(jq ".business_ids | length" data-files/business_ids.json);
echo $num_businesses;

typeset -i i END
let END=$num_businesses i=0;

while ((i<=END-1)); do

	cluster=(
				$(jq -r ".business_ids[$i] .business_name" data-files/business_ids.json)
				$(jq -r ".business_ids[$i] .id" data-files/business_ids.json)
			);

	# prerequisites
	IFS=$'\n' api_key_file=($(cat data-files/zomato_api_key.txt));
	api_key=${api_key_file[0]};
	random_proxy=$(shuf -n 1 data-files/proxy_list.txt);

	business_name=${cluster[0]};
	id=${cluster[1]};

	api_retrieve_reviews_url="https://api.zomato.com/v2/reviews.json/$id/user?count=100&apikey=$api_key"
	$(wget -e use_proxy=yes http_proxy=$random_proxy --output-document="files/$business_name.json" $api_retrieve_reviews_url); true || $(wget --output-document="files/$business_name.json" $api_retrieve_reviews_url);
	let i++;
done
