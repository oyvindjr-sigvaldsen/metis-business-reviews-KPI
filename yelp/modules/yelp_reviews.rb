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

		# __ITERATE review_page_urls []__
		review_page_urls.each do |review_page_url|
			pp review_page_url

			# __PRE-REQUISITES__
				# => browser used to scrape review data from review_page_url -> review_wrappers.each do |review_wrapper| 
			browser = Watir::Browser.new :safari
			browser.goto(review_page_url)

				# => used as a parent node in retrieving parameters using the .css() method for each of the parameter instance
				#    vars for global-classes/review.rb

			net_http_response = Net::HTTP.get_response(URI.parse(review_page_url))
			puts net_http_response.code
			#review_page = Nokogiri::HTML()
			review_wrappers = review_page.css("div.lemon--div__373c0__1mboc.sidebarActionsHoverTarget__373c0__2kfhE.arrange__373c0__UHqhV.gutter-12__373c0__3kguh.grid__373c0__29zUk.layout-stack-small__373c0__3cHex.border-color--default__373c0__2oFDT")
			puts review_wrappers.length

			# __ITERATE review_wrappers.length__
			(0..review_wrappers.length).step(1) do |y|

				review_wrapper = review_wrappers[y]
				puts review_wrapper
				puts "\n\n"
				Kernel.exit
			end
			browser.close
		end
	end
end
