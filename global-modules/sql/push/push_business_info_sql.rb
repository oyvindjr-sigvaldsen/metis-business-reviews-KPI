def push_business_info_sql(business_info_instances, sql_table)

	# https://docs.microsoft.com/en-us/azure/mysql/connect-ruby
	username, password = retrieve_sql_credentials("../mysql_credentials.json")
	connection = Mysql2::Client.new(:host => "localhost", :username => username, :database => "metis_development", :password => password)

	connection.query("DELETE FROM #{sql_table}")

	business_info_instances.each do |instance|

		begin
			connection = Mysql2::Client.new(:host => "localhost", :username => username, :database => "metis_development", :password => password)
			connection.query("INSERT INTO #{sql_table} VALUES(
																'#{instance.instance_variable_get(:@name)}',
																'#{instance.instance_variable_get(:@number_of_reviews)}',
																'#{instance.instance_variable_get(:@price_point)}',
																'#{instance.instance_variable_get(:@cuisines)}',
																'#{instance.instance_variable_get(:@star_rating)}'
															)")
			connection.close

		# catch Mysql2 syntax and other errors
		rescue Mysql2::Error => error
			puts error
		end
	end
end
