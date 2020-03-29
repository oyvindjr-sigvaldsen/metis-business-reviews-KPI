def clear_table_sql(sql_table_name)

	connection = create_connection_sql("../credentials/sql_credentials.json")

	begin
		connection.query("DELETE FROM #{sql_table_name}")
		connection.close

	rescue => error
		puts error
	end
end
