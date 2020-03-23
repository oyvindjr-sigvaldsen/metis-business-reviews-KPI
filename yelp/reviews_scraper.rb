require_relative "../requirements"
require_relative "../global-modules/retrieve_sql_credentials"

require_relative "classes/review"
require_relative "modules/retrieve_html_file_paths"

def reviews_scraper(html_files)

	review_info_selectors = [
							"#wrap > div.main-content-wrap.main-content-wrap--full > div > div.lemon--div__373c0__1mboc.u-space-t3.u-space-b6.border-color--default__373c0__2oFDT > div > div > div.lemon--div__373c0__1mboc.stickySidebar--heightContext__373c0__133M8.tableLayoutFixed__373c0__12cEm.arrange__373c0__UHqhV.u-space-b6.u-padding-b4.border--bottom__373c0__uPbXS.border-color--default__373c0__2oFDT > div.lemon--div__373c0__1mboc.arrange-unit__373c0__1piwO.arrange-unit-grid-column--8__373c0__2yTAx.u-padding-r6.border-color--default__373c0__2oFDT > div:nth-child(9) > section:nth-child(2) > div.lemon--div__373c0__1mboc.spinner-container__373c0__N6Hff.border-color--default__373c0__2oFDT > div > ul > li:nth-child(4) > div > div.lemon--div__373c0__1mboc.arrange-unit__373c0__1piwO.arrange-unit-grid-column--8__373c0__2yTAx.border-color--default__373c0__2oFDT > div.lemon--div__373c0__1mboc.u-space-t1.u-space-b1.border-color--default__373c0__2oFDT > div > div:nth-child(1) > span > div", # star_rating
							"#wrap > div.main-content-wrap.main-content-wrap--full > div > div.lemon--div__373c0__1mboc.u-space-t3.u-space-b6.border-color--default__373c0__2oFDT > div > div > div.lemon--div__373c0__1mboc.stickySidebar--heightContext__373c0__133M8.tableLayoutFixed__373c0__12cEm.arrange__373c0__UHqhV.u-space-b6.u-padding-b4.border--bottom__373c0__uPbXS.border-color--default__373c0__2oFDT > div.lemon--div__373c0__1mboc.arrange-unit__373c0__1piwO.arrange-unit-grid-column--8__373c0__2yTAx.u-padding-r6.border-color--default__373c0__2oFDT > div:nth-child(9) > section:nth-child(2) > div.lemon--div__373c0__1mboc.spinner-container__373c0__N6Hff.border-color--default__373c0__2oFDT > div > ul > li:nth-child(4) > div > div.lemon--div__373c0__1mboc.arrange-unit__373c0__1piwO.arrange-unit-grid-column--8__373c0__2yTAx.border-color--default__373c0__2oFDT > div.lemon--div__373c0__1mboc.u-space-t1.u-space-b1.border-color--default__373c0__2oFDT > div > div.lemon--div__373c0__1mboc.arrange-unit__373c0__1piwO.arrange-unit-fill__373c0__17z0h.border-color--default__373c0__2oFDT > span" #date
						]


	# prerequisites
	review_number = 1
	number_reviews_page = 20

	begin
		review_instances = []

		html_files.each do |html_file|

			# TODO: make use open-uri or net/http to open live webpage using URL
			parsed_page = Nokogiri::HTML(open(html_file))
			review = []

			(review_number..number_reviews_page).step(1) do |n|

				review_base_xpath = "//*[@id='wrap']/div[3]/div/div[3]/div/div/div[2]/div[1]/div[4]/section[2]/div[2]/div/ul/li[#{n}]/div/div[2]"

				#results = uparsed_data.css("div.")
			end
		end

	# catch 'no such file'
	rescue Errno::ENOENT => error
		puts error
	end
end

html_files = retrieve_html_file_paths()
reviews_scraper(html_files)
