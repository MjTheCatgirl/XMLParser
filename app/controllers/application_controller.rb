class ApplicationController < ActionController::Base
	# Define class for each property object
	class Property
    def initialize(property_id, name, email)
      @property_id = property_id
      @name = name
      @email = email
    end
    attr_reader :property_id
    attr_reader :name
    attr_reader :email
  end

	# action to parse and render data from webpage with property info in XML
	def scrape_properties
		# Pull in the page to parse
		require 'open-uri'
		# doc is verified opening correctly
		@doc = Nokogiri::XML(open("https://s3.amazonaws.com/abodo-misc/sample_abodo_feed.xml"))
		
		@propertiesArray = []
		# Narrow down to properties in Madison to add to array
		# Select all property elements that have a city element named "Madison"
		# THIS IS CURRENTLY EMPTY AND SHOULD NOT BE
  		@properties = @doc.xpath('//Property[City="Madison"]')
  		@properties.each do |property|
    		# Get values for id, name and email from each matching property to add to output array
    		@property_id=property.attr('IDValue')
    		@name=property.attr('MarketingName')
    		@email=property.attr('Email')
    		@propertiesArray << Property.new(property_id, name, email)
  		end
  		# Add render here
  		render template: 'scrape_properties'
	end
end
