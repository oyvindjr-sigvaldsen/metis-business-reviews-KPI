def retrieve_business_data_token(data_token, i)

	begin
		business_data_tokens_file = File.open "../data-files/business_data_tokens.json"
		json_data = JSON.load business_data_tokens_file
		business_data_tokens_file.close

		business_name = json_data[i]["business_name"].to_s
		business_data_token = json_data[i]["data_tokens"][data_token].to_s

		return business_name, business_data_token

	rescue
		return nil
	end
end
