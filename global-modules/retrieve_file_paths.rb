def retrieve_file_paths(json_file_path, extension)

	begin
		business_urls = File.open json_file_path
		json_data = JSON.load business_urls
		business_urls.close

		main_array = json_data
		file_paths = []

		(0..main_array.length-1).step(1) do |i|
			business_name = main_array[i]["business_name"]
			file_paths.push("retrieve-files/files/#{business_name}#{extension}")
		end

		return file_paths

	# catch incorrect json_file_path error
	rescue nil::NilClass => error
		puts error
	end
end
