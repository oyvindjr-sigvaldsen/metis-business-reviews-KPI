require_relative "../../requirements"
require_relative "../../global-classes/review"

require_relative "../../global-modules/retrieve_sql_credentials"
require_relative "../../global-modules/retrieve_html_file_paths"

def reviews_scraper(html_files)

	begin

		html_files.each_with_index do |html_file, i|

			parsed_page = Nokogiri::HTML(open(html_file))

			# TODO: make get hidden html text using witer
			# get url for current html_file
			business_urls = File.open "retrieve-html-files/data-files/business_urls.json"
			json_data = JSON.load business_urls
			business_urls.close

			html_file_url = json_data["business_urls"][i]["url"]
			#browser = Watir::Browser.new :safari
			#browser.goto(html_file_url)

			review_wrapper = parsed_page.css("div.ui_column")
			titles = []

			# for clicking "more" buttons and revealing full review text
			#more_onclick_span =  browser.spans(visible: true, class: ["taLnk", "ulBlueLinks"])
			#more_onclick_span[0].fire_event :click

			#sleep 2

			# 0.. num of reviews per page = 10
			(0..review_wrapper.css("span.noQuotes").length-1).step(1) do |i|

				begin

					# title
					raw_title = review_wrapper.css("span.noQuotes")[i].text.gsub!(/^\“|\”?$/, "").tr("'", "")

					title = raw_title.split.join(" ").chomp(".").split.map(&:capitalize)*" ".to_s

					#visit_date
					raw_visit_date = review_wrapper.css("div[data-prwidget-name=reviews_stay_date_hsx]")[i].text

					visit_date_month = Date::MONTHNAMES.index(raw_visit_date.split[3]).to_i
					visit_date_year = raw_visit_date.split[4].to_i
					visit_date = Date.parse("#{1}-#{visit_date_month}-#{visit_date_year}")

					# review_date
					raw_review_date = review_wrapper.css("span.ratingDate")[i].attribute("title").text.to_s

					review_date_month =  Date::MONTHNAMES.index(raw_review_date.split.first).to_i
					review_date_day = raw_review_date.split[1].chomp(",").to_i
					review_date_year = raw_review_date.split[2].to_i
					review_date = Date.parse("#{review_date_day}-#{review_date_month}-#{review_date_year}")

					# star_rating
					raw_star_rating = review_wrapper.css("div#REVIEWS").css("span.ui_bubble_rating")[i]

					star_rating = raw_star_rating.attribute("class").text.scan(/\d+/).first.to_f / 10.00

					# text
					#text_raw = browser.ps(visible: true, class: "partial_entry")[i].inner_text

					# 	>> capitalize every letter following full stops and other sentence enders
					#text = text_raw.split.join(" ").gsub(/([a-z])((?:[^.?!]|\.(?=[a-z]))*)/i) { $1.upcase + $2.rstrip }

					# photos
					begin

						puts title
						photos_raw = review_wrapper.css("div.inlinePhotosWrapper")[0].css("img.centeredImg").length
						pp photos_raw

						if photos_raw.include? ".jpg"
							pp photos_raw
						else
							nil
							pp photos_raw
						end

					rescue
						"NO IMAGE"
						next
					end

					#puts text
					puts "_________________\n"
					puts "_________________\n"

				# in case of nil value error
				rescue NoMethodError => error
					titles.push(nil)
					puts error
					next
				end
			end
			#browser.quit
			puts "\n\n"
		end

	# catch 'no such file'
	rescue Errno::ENOENT => error
		puts error
	end
end

html_files = retrieve_html_file_paths("retrieve-html-files/data-files/business_urls.json")
reviews_scraper(html_files)
