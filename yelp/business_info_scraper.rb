require_relative "../requirements"
require_relative "../global-modules/retrieve_sql_credentials"

require_relative "classes/business_info"
require_relative "modules/retrieve_html_file_paths"

def business_info_scraper(html_files)

	# business info xpath array
	business_info_xpaths = [
							"//*[@id='wrap']/div[3]/div/div[3]/div/div/div[2]/div[1]/div[1]/div/div/div[1]/h1", # name
							"//*[@id='wrap']/div[3]/div/div[3]/div/div/div[2]/div[1]/div[1]/div/div/div[2]/div[2]/p", # num reviews
							"//*[@id='wrap']/div[3]/div/div[3]/div/div/div[2]/div[1]/div[1]/div/div/span[1]/span", # price point
							"//*[@id='wrap']/div[3]/div/div[3]/div/div/div[2]/div[1]/div[1]/div/div/span[2]", # cuisine(s)
							"//*[@id='wrap']/div[3]/div/div[3]/div/div/div[2]/div[1]/div[1]/div/div/div[2]/div[1]/span/div", # star rating
						]

	# TODO: create class for business, review_user
	begin
		business_info_instances = []

		html_files.each do |html_file|

			parsed_page = Nokogiri::HTML(open(html_file))
			business_info = []

			business_info_xpaths.each_with_index do |xpath, i|

				# add index exceptions (int)
				if i == 4
					info = parsed_page.xpath(xpath).attribute("aria-label")
					business_info.push(info)
				else
					info = parsed_page.xpath(xpath).method(:text)
					business_info.push(info.call.to_s)
				end
			end

			business_info_instance = BusinessInfo.new(*business_info)
			business_info_instances.push(business_info_instance)
		end
		return business_info_instances

	# catch 'no such file'
	rescue Errno::ENOENT => error
		puts error
	end
end

def push_business_info_sql(business_info_instances)

	# https://docs.microsoft.com/en-us/azure/mysql/connect-ruby
	username, password = retrieve_sql_credentials("../mysql_credentials.json")
	connection = Mysql2::Client.new(:host => "localhost", :username => username, :database => "metis_development", :password => password)

	connection.query("DELETE FROM yelp_business_info")

	business_info_instances.each do |instance|

		begin
			connection = Mysql2::Client.new(:host => "localhost", :username => username, :database => "metis_development", :password => password)
			connection.query("INSERT INTO yelp_business_info VALUES(
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

html_files = retrieve_html_file_paths()
business_info_instances = business_info_scraper(html_files)
push_business_info_sql(business_info_instances)
