require 'nokogiri'
require 'open-uri'

module HP
	def HP.get_search_page(search_terms)
		"http://www.shopping.hp.com/en_US/home-office/-/search-SimpleOfferSearch?SearchType=ink_toner_printer&InkTonerType=printer&PageSize=15&SearchTerm=#{search_terms}"
	end

	def HP.get_supplies(search_terms)
		search_page = Nokogiri::HTML(open(HP.get_search_page(search_terms)))

		search_results = search_page.css('a.btn.btn-w-auto')
		cartridges = Array.new
		
		return nil if search_results.empty?
		
		supplies_page = Nokogiri::HTML(open(search_results[0]['href']))
		
		# HP supplies page has several pages of similar table structures in sub pages hidden by javascript, so we want to be sure we only grab the ones relating
		# to cartridges
		div_cartridges = supplies_page.css('div#cartridges')
		# The supplies page alternates the class for each TR result element, so I grab the first table (table.tablesorter) and take all TRs into a collection
		tablesorter = div_cartridges.css('table.tablesorter')
		
		tablesorter.each do |table|
			rows = table.css('tr') 
			rows.shift
		
			rows.each do |tr|
				cartridges << tr.css('a')[0].content
			end
		end
		
		cartridges
	end
end