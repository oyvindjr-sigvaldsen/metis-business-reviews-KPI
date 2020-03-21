require "json"

def retrieve_sql_credentials(credentials_path)

	credentials_file = open(credentials_path)
	json = credentials_file.read
	parsed_json = JSON.parse(json)

	return parsed_json["username"], parsed_json["password"]
end
