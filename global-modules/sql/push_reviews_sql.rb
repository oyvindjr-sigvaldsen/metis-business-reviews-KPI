def push_reviews_sql(instance, sql_table_name, total_number_of_reviews)

	business_name = instance.instance_variable_get(:@business_name)
	title = instance.instance_variable_get(:@title)
	visit_date = instance.instance_variable_get(:@visit_date)
	review_date = instance.instance_variable_get(:@review_date)
	star_rating = instance.instance_variable_get(:@star_rating)
	text = instance.instance_variable_get(:@text)
	photos = instance.instance_variable_get(:@photos)
	username = instance.instance_variable_get(:@username)
	number_of_reviews = instance.instance_variable_get(:@number_of_reviews)

	# https://docs.microsoft.com/en-us/azure/mysql/connect-ruby
	connection = create_connection_sql("../credentials/sql_credentials.json")

	raw_sql_table_length = connection.query("SELECT COUNT(*) FROM #{sql_table_name};")
	sql_table_length = raw_sql_table_length.to_a[0]["COUNT(*)"].to_i


	if sql_table_length != total_number_of_reviews
		begin
			connection.query "REPLACE INTO #{sql_table_name}
								SET business_name = '#{business_name}',
								title =  '#{title}',
								visit_date = '#{visit_date}',
								review_date = '#{review_date}',
								star_rating = '#{star_rating}',
								text = '#{text}',
								photos = '#{photos}',
								username = '#{username}',
								number_of_reviews = '#{number_of_reviews}';"
			connection.close

		# catch Mysql2 syntax and other errors
		rescue Mysql2::Error => error
			puts error
		end
	else
		begin
			connection.query("UPDATE #{sql_table_name}
							SET business_name = '#{business_name}',
							title = '#{title}',
							visit_date = '#{visit_date}',
							review_date = '#{review_date}',
							star_rating = '#{star_rating}',
							text = '#{text}',
							photos = '#{photos}',
							username = '#{username}',
							number_of_reviews = '#{number_of_reviews}'
							WHERE text = '#{text}';")
			connection.close

		# catch Mysql2 syntax and other errors
		rescue Mysql2::Error => error
			puts error
		end
	end
end
