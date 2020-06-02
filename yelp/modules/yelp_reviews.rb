def reviews_scraper(html_file_paths)

	# __ITERATE html_file_paths []__
	# => html_file_paths var returned from retrieve_file_paths method in global-modules/retrieve_file_paths.rb
	html_file_paths.each_with_index do |html_file_path, i|

		# __PRE-REQUISITES__
		# => business_review_site_homepage only used for retrieving business_number_of_reviews, rest of review_page_urls
		#    utilize automated web-browser using the Watir gem
		business_review_site_homepage = Nokogiri::HTML(open(html_file_path))
		business_name, business_base_url = retrieve_business_data_token("yelp_url", i)

		# __REVIEW PAGE URLS__
		# business number of reviews
		raw_business_number_of_reviews = business_review_site_homepage.css("p.lemon--p__373c0__3Qnnj.text__373c0__2pB8f.text-color--mid__373c0__3G312.text-align--left__373c0__2pnx_.text-size--large__373c0__1568g").text.chomp(" reviews").to_i
		business_number_of_reviews = raw_business_number_of_reviews.floor_to(20).to_i

		# => programatically generate review_page_urls based on business_base_url using http flag ""start="" -> review_number
		#    in increments of n = 20
		review_page_urls = []

		(0..business_number_of_reviews).step(20) do |x|
			review_page_url = (business_base_url + "?start=#{x}").to_s
			review_page_urls.push(review_page_url)
		end

		#system("mkdir #{business_name};")

		progress_bar = ProgressBar.new(review_page_urls.length, :bar, :counter, :eta, :rate)

		# __ITERATE review_page_urls []__
		review_page_urls.each do |review_page_url|

			puts review_page_url.yellow

			# __PRE-REQUISITES__
			#system("export LANG=en_GB.UTF-8; cd #{business_name}; wget -O #{business_name}_#{review_page_url.scan(/\d+/)[-1]}.html #{review_page_url};")

			review_page = Nokogiri::HTML(open("#{business_name}/#{business_name}_#{review_page_url.scan(/\d+/)[-1]}.html"))

			# => used as a parent node in retrieving parameters using the .css() method for each of the parameter instance
			#    vars for global-classes/review.rb
			review_wrappers = review_page.css("div.lemon--div__373c0__1mboc.sidebarActionsHoverTarget__373c0__2kfhE.arrange__373c0__UHqhV.gutter-12__373c0__3kguh.grid__373c0__29zUk.layout-stack-small__373c0__3cHex.border-color--default__373c0__2oFDT")

			# __ITERATE review_wrappers.length__
			(0..review_wrappers.length-1).step(1) do |y|

				review_wrapper = review_wrappers[y]

				# text
				raw_text = review_wrapper.css("span.lemon--span__373c0__3997G[lang='en']").text.to_s
				text = raw_text.split(" ").to_a

				(0..text.length-1).step(1) do |i|

					begin
						if text[i][0] == " "
							text[i][0] = ""
						end

						if text[i-1][-1] == "."
							text[i] = text[i].capitalize
						end

						if text[i+1] == ","
							text[i] = text[i] + text[i+1]
							text[i+1] = nil

						end

						if text[i].include? "!"
							text[i] = text[i].split("!")[0] + "! " + text[i].split("!")[1].capitalize
						elsif text[i].include? "."
							text[i] = text[i].split(".")[0] + ". " + text[i].split(".")[1].capitalize
						end

						if text[i] == ""
							text[i] = nil
						end
					rescue => error
						#puts error
						next
					end
				end

				#pp (text - [nil])
				text = (text - [nil]).join(" ").tr("''", "").gsub(/[^[:alnum:][:blank:][:punct:]]/, '').squeeze(' ').strip

				# review_date
				raw_review_date = review_wrapper.css("span.lemon--span__373c0__3997G.text__373c0__2pB8f.text-color--mid__373c0__3G312.text-align--left__373c0__2pnx_").text

				review_date_month = raw_review_date.split("/")[0].to_i
				review_date_year = raw_review_date.split("/")[2].to_i
				review_date_day = raw_review_date.split("/")[1].to_i
				review_date = Date.parse("#{review_date_day}-#{review_date_month}-#{review_date_year}").to_s

				# star_rating
				star_rating = review_wrapper.css("div.lemon--div__373c0__1mboc.i-stars__373c0__3UQrn").attribute("aria-label").text.to_i

				# photos
				raw_photos_src_urls = review_wrapper.css("img.photo-box-img__373c0__O0tbt")
				photos_src_urls = []

				raw_photos_src_urls.each do |raw_photos_src_url|
					photos_src_urls.append(raw_photos_src_url.attribute("src").text.to_s)
				end

				if photos_src_urls.drop(1).length > 0
					photos_src_urls = photos_src_urls.drop(1)
				else
					photos_src_urls = nil
				end

				# username
				username = review_wrapper.css("span.lemon--span__373c0__3997G.text__373c0__2pB8f.fs-block.text-color--blue-dark__373c0__PGWTX.text-align--left__373c0__2pnx_.text-weight--bold__373c0__3HYJa").text

				# number_of_reviews
				raw_number_of_reviews = review_wrapper.css("span.lemon--span__373c0__3997G.text__373c0__2pB8f.text-color--normal__373c0__K_MKN.text-align--left__373c0__2pnx_.text-size--small__373c0__3SGMi").text
				number_of_reviews = raw_number_of_reviews.split(" ").to_a[-2].tr("reviews", "").to_i

				review_instance = Review.new(business_name, nil, nil, review_date, star_rating, text, photos_src_urls, username, number_of_reviews)
				push_review_sql(review_instance, "yelp_reviews", 10000000000)
			end
			progress_bar.increment!
		end
	end
end
