def reviews_scraper(html_files)

	begin

		html_files.each_with_index do |html_file, i|

			parsed_page = Nokogiri::HTML(open(html_file))

			# get url for current html_file
			business_urls = File.open "../data-files/business_data_tokens.json"
			json_data = JSON.load business_urls
			business_urls.close

			# get array of tripadvisor urls including review # flag "-or"
			raw_html_file_url = json_data[i]["data_tokens"]["tripadvisor_url"]
			puts raw_html_file_url, i
			review_url_number = (parsed_page.css("a.pageNum.last.cx_brand_refresh_phase2").attribute("data-page-number").text.to_i-1)
			puts review_url_number

			html_file_urls = []

			(0..review_url_number).step(1) do |y|
				site_number = y*10
				html_file_url = raw_html_file_url.clone
				html_file_url["-Reviews"] = "-Reviews-or" + site_number.to_s.chomp("s")
				html_file_urls.push(html_file_url)
			end

			#(0..html_file_urls.length-3).step(1) do |y|
			html_file_urls.each do |html_file_url|

				#html_file_url = html_file_urls[y]
				puts html_file_url
				browser = Watir::Browser.new :safari, headless: true
				browser.goto(html_file_url)

				parsed_page = Nokogiri::HTML(open(html_file_url))

				review_wrapper = parsed_page.css("div.ui_column")

				# for clicking "more" buttons and revealing full review text
				begin
					more_onclick_span =  browser.spans(visible: true, class: ["taLnk", "ulBlueLinks"])
					more_onclick_span[0].fire_event :click
					sleep 2
				rescue
					nil
				end

				# 0.. num of reviews per page = 10
				(0..review_wrapper.css("span.noQuotes").length-1).step(1) do |i|

					begin

						# business_name
						business_name =  html_file[21...].to_s.chomp(".html")
						puts business_name

						# title
						raw_title = review_wrapper.css("span.noQuotes")[i].text.gsub!(/^\“|\”?$/, "").tr("'", "")

						title = raw_title.split.join(" ").chomp(".").split.map(&:capitalize)*" ".to_s

						#visit_date
						raw_visit_date = review_wrapper.css("div[data-prwidget-name=reviews_stay_date_hsx]")[i].text

						begin
							visit_date_month = Date::MONTHNAMES.index(raw_visit_date.split[3]).to_i
							visit_date_year = raw_visit_date.split[4].to_i
							visit_date = Date.parse("#{1}-#{visit_date_month}-#{visit_date_year}")
						rescue
							visit_date = nil
						end

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
						text_raw = browser.ps(visible: true, class: "partial_entry")[i].inner_text

						# 	>> capitalize every letter following full stops and other sentence enders
						text = text_raw.split.join(" ").gsub(/([a-z])((?:[^.?!]|\.(?=[a-z]))*)/i) { $1.upcase + $2.rstrip }.tr("''", "")

						# photos
						photos_raw = parsed_page.css("div.review-container")[i].css("div.inlinePhotosWrapper").css("img.centeredImg.noscript")

						photos = []

						if photos_raw.length > 0

							(0..photos_raw.length-1).step(1) do |x|
								photo_src = photos_raw[x].attribute("src").to_s
								photos.push(photo_src)
							end
						else
							nil
						end

						if photos.length == 0
							photos = nil
						end

						# username
						username_raw = parsed_page.css("div.member_info")[i]

						username = username_raw.css("div")[0].text.to_s.split.join(" ")

						# number_of_reviews
						number_of_reviews_raw = parsed_page.css("span.badgeText")
						number_of_reviews = number_of_reviews_raw[i].text.chomp("reviews").split.join(" ").to_i

						review_instance = Review.new(business_name, title, visit_date.to_s, review_date.to_s, star_rating, text, photos, username, number_of_reviews)
						push_reviews_sql(review_instance, "tripadvisor_reviews", 8425)

					# in case of nil value error
					rescue NoMethodError => error
						puts error
						next
					end
				end
				browser.close
			end
		end
	end
end
