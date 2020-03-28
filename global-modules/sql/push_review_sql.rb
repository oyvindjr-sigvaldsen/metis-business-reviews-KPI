def push_reviews_sql(review_instances, sql_table)

	# https://docs.microsoft.com/en-us/azure/mysql/connect-ruby
	username, password = retrieve_sql_credentials("../mysql_credentials.json")
	connection = Mysql2::Client.new(:host => "localhost", :username => username, :database => "metis_development", :password => password)

	connection.query("DELETE FROM #{sql_table}")

	review_instances.each do |instance|

		begin
			connection = Mysql2::Client.new(:host => "localhost", :username => username, :database => "metis_development", :password => password)
			connection.query("INSERT INTO #{sql_table} VALUES(
																'#{instance.instance_variable_get(:@business_name)}',
																'#{instance.instance_variable_get(:@title)}',
																'#{instance.instance_variable_get(:@visit_date)}',
																'#{instance.instance_variable_get(:@review_date)}',
																'#{instance.instance_variable_get(:@star_rating)}',
																'#{instance.instance_variable_get(:@text)}',
																'#{instance.instance_variable_get(:@photos)}',
																'#{instance.instance_variable_get(:@username)}',
																'#{instance.instance_variable_get(:@number_of_reviews)}'
															)")
			connection.close

		# catch Mysql2 syntax and other errors
		rescue Mysql2::Error => error
			puts error
		end
	end
end
