def retrieve_html_file_paths(json_file_path)

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

# TODO: add json_file_path to call of retrieve_html_file_paths function in business_info.rb
# TODO: update local paths for BusinessInfo class and retrieve_html_file_paths function