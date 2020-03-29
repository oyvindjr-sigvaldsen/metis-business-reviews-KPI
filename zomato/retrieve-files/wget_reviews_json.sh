#!/bin/bash

wget_reviews_json() {

	num_businesses=$(jq " . | length" $data_tokens_file_path);
	typeset -i i END
	let END=$num_businesses i=0;

	while ((i<=END-1)); do

		# prerequisites
		IFS=$'\n' api_key_file=($(cat ../../credentials/zomato_api_key.txt));
		api_key=${api_key_file[0]};
		random_proxy=$(shuf -n 1 ../../data-files/proxy_list.txt);

		cluster=(
					$(jq -r ".[$i] .business_name" $data_tokens_file_path)
					$(jq -r ".[$i] .data_tokens .zomato_id" $data_tokens_file_path)
				);

		business_name=${cluster[0]};
		data_token=${cluster[1]};

		api_retrieve_reviews_url="https://api.zomato.com/v2/reviews.json/$data_token/user?count=100&apikey=$api_key"
		$(wget -e use_proxy=yes http_proxy=$random_proxy --output-document="files/$business_name.json" $api_retrieve_reviews_url); true || $(wget --output-document="files/$business_name.json" $api_retrieve_reviews_url);
		let i++;
	done
}

export LANG=en_GB.UTF-8;
cd files; rm *.json; cd ..;

data_tokens_file_path=../../data-files/business_data_tokens.json
wget_reviews_json $data_tokens_file_path
