class SupplyListing
	def initialize(term, brand, supplies)
		@term = term
		@brand = brand
		@supplies = supplies
	end
	
	attr_accessor :term, :brand, :supplies
end