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
		# doc is verified opening correctly, page must be open in browser
		@doc = Nokogiri::XML(open("https://s3.amazonaws.com/abodo-misc/sample_abodo_feed.xml"))
		
		@propertiesArray = []
		# This should give a nodelist of all Property nodes that have a City descendent somewhere with
		# the text value = 'Blue'
  		@properties = @doc.xpath("//Property[descendant::City[text()='Madison']]")
  		@listSize = @properties.length
  		# Now, want to take each of these and make a Property object out of each to add to the array
  		
  		
  		# Add render here
  		render template: 'scrape_properties'
	end
end
