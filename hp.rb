require 'nokogiri'
require 'open-uri'

def get_search_page(search_terms)
	"http://www.shopping.hp.com/en_US/home-office/-/search-SimpleOfferSearch?SearchType=ink_toner_printer&InkTonerType=printer&PageSize=15&SearchTerm=#{search_terms}"
end

def get_supplies(search_terms)
	search_page = Nokogiri::HTML(open(get_search_page(search_terms)))

	search_results = search_page.css('a.btn.btn-w-auto')
	cartridges = Array.new
	
	search_results.each do |result|
		supplies_page = Nokogiri::HTML(open(result['href']))
		
		# The supplies page alternates the class for each TR result element, so I grab the first table (table.tablesorter) and take all TRs into a collection
		tablesorter = supplies_page.css('table.tablesorter')[0].css('tr') 
		tablesorter.shift
		
		tablesorter.each do |tr|
			cartridges << tr.css('a')[0].content
		end
	end
	
	cartridges
end