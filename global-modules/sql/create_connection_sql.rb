def create_connection_sql(sql_credentials_file_path)

	begin
		# retrieve sql credentials
		credentials_file = open(sql_credentials_file_path)
		json = credentials_file.read
		parsed_json = JSON.parse(json)

		# create connection object
		connection = Mysql2::Client.new(:host => "localhost", :username => parsed_json["username"], :database => "metis_development", :password => parsed_json["password"])

		return connection

	rescue => error
		puts error
	end
end
