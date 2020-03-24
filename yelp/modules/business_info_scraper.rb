require_relative "../../requirements"
require_relative "../../global-classes/business_info"

require_relative "../../global-modules/retrieve_sql_credentials"
require_relative "../../global-modules/push_business_info_sql"
require_relative "../../global-modules/retrieve_html_file_paths"

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

			business_info_instance = BusinessInfo.new(
														business_info[0].to_s.tr("'", ""),
														business_info[1].chomp("reviews").to_i,
														business_info[2].to_s.chomp(" "),
														business_info[3].to_s.tr(" ", "").split(",").to_a,
														business_info[4].to_s.chomp("star rating").to_f
													)
			business_info_instances.push(business_info_instance)
		end
		return business_info_instances

	# catch 'no such file'
	rescue Errno::ENOENT => error
		puts error
	end
end

html_files = retrieve_html_file_paths("retrieve-html-files/data-files/business_urls.json")
business_info_instances = business_info_scraper(html_files)
push_business_info_sql(business_info_instances, "yelp_business_info")
