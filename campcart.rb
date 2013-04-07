require 'sinatra'
require 'pstore'

require './supply_listing'
require './lexmark'
require './hp'

# DEBUG ONLY
require 'sinatra/reloader'
# DEBUG ONLY

def scrape(search_terms, brand)
	brand = brand.to_sym
	
	case brand
	when :lexmark
		Lexmark.get_supplies(search_terms)
	when :hp
		HP.get_supplies(search_terms)
	end
end

get '/' do
	#File.delete("stored_supplies.pstore") if File.exists?("stored_supplies.pstore")
	erb :home, :locals => {:post => false}
end

post '/' do
	terms = params[:terms].delete(" ").downcase
	supplies_store = PStore.new("stored_supplies.pstore")
	
	stored_supplies_from_terms = nil
	supplies_store.transaction(true) do
		stored_supplies_from_terms = supplies_store[terms]
	end
	
	cartridges = nil
	already_stored = false
	
	if stored_supplies_from_terms != nil then
		cartridges = stored_supplies_from_terms.supplies
		already_stored = true
	else
		cartridges = scrape(terms, params[:brand])
	end
	
	erb :home, :locals => {:post => true, :cartridges => cartridges, :terms => terms, :brand => params[:brand], :already_stored => already_stored}
end

post '/store' do
	listing = SupplyListing.new(params[:terms], params[:brand], scrape(params[:terms], params[:brand]))
	supplies_store = PStore.new("stored_supplies.pstore")
	
	supplies_store.transaction do
		supplies_store[listing.term] = listing
	end
	
	"Thanks for contributing!"
end