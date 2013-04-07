require 'nokogiri'
require 'open-uri'

module Lexmark
	def Lexmark.get_product_code(url)
		/&prodId=(\d{4})-/.match(url)[1]
	end

	def Lexmark.get_supplies_page(product_code)
		"http://www1.lexmark.com/US/en/catalog/suppliesresults.jsp?prodId=#{product_code}"
	end

	def Lexmark.get_search_page(search_terms)
		"http://www1.lexmark.com/US/en/search/allproductresults.jsp?question=#{search_terms}&searchCategory=All+Products&searchType=categorySearch&_dyncharset=UTF-8"
	end

	def Lexmark.get_supplies(search_terms)
		search_page = Nokogiri::HTML(open(Lexmark.get_search_page(search_terms)))

		if (!search_page.css('span.title-note').text.start_with?("> We're sorry")) then # We have results!
			first_result = search_page.css('h3 a')[0]['href']
			supplies_page = Nokogiri::HTML(open(Lexmark.get_supplies_page(Lexmark.get_product_code(first_result))))
			
			ink_tables = supplies_page.css('table.ink-toner')
			
			cartridges = Array.new
			
			ink_tables.each do |table|
				rows = table.css('tbody tr')
				rows.each do |row|
					cartridge_name = row.css('td')[0].css('a')[0].text
					cartridges << cartridge_name
				end
			end
			
			cartridges
		else
			nil
		end
	end
end