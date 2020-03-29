#!/bin/bash

wget_html() {

	num_businesses=$(jq ". | length" $data_tokens_file_path);
	typeset -i i END
	let END=$num_businesses i=0;

	while ((i<=END-1)); do

		max_sleep=30
		random_sleep=$(shuf -i 1-$max_sleep -n 1);
		random_proxy=$(shuf -n 1 data-files/proxy_list.txt);

		cluster=(
					$(jq -r ".[$i] .business_name" $data_tokens_file_path)
					$(jq -r ".[$i] .data_tokens .tripadvisor_url" $data_tokens_file_path)
				);

		business_name=${cluster[0]}
		url=${cluster[1]};

		$(wget -e use_proxy=yes http_proxy=$random_proxy --output-document="files/$business_name.html" $url); true || $(wget --output-document="files/$business_name.html" $url);

		source ./../../global-modules/progress-bar.sh;
		echo "random_sleep : "$random_sleep" seconds";
		progress-bar $random_sleep;

		let i++;
	done
}

export LANG=en_GB.UTF-8;
cd files; rm *.html; cd ..;

data_tokens_file_path=../../data-files/business_data_tokens.json
wget_html $data_tokens_file_path
