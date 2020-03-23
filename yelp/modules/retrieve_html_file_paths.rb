def retrieve_html_file_paths()

	json_file_path = "retrieve-html-files/data-files/business_urls.json"

	begin
		business_urls = File.open json_file_path
		json_data = JSON.load business_urls
		business_urls.close

		main_array = json_data["business_urls"]
		html_files = []

		(0..main_array.length-1).step(1) do |i|
			business_name = main_array[i]["business_name"]
			html_files.push("retrieve-html-files/html-files/#{business_name}.html")
		end

		return html_files

	# catch incorrect json_file_path error
	rescue nil::NilClass => error
		puts error
	end
end
