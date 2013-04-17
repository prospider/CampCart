require 'nokogiri'
require 'open-uri'

module Samsung
	def Samsung.get_search_page_url(search_terms)
		"http://www.samsung.com/ca/function/search/espsearchResult?input_keyword=#{search_terms}&keywords=#{search_terms}"
	end
	
	def Samsung.get_supplies(search_terms)
		# Scrape the general search page
		search_page = Nokogiri::HTML(open(get_search_page_url(search_terms)))
		
		# URL is in a hidden input element
		detail_url = 