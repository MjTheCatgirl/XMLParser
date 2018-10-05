class ApplicationController < ActionController::Base
	# Define class for each property object
	class Property
    def initialize(property_id, name, email)
      @property_id = property_id
      @name = name
      @email = email
    end

   def property_id
   	@property_id
   end

   def name
   	@name
   end

   def email
   	@email
   end
  end

	# action to parse and render data from webpage with property info in XML
	def scrape_properties
		# Pull in the page to parse
		require 'open-uri'
		# doc is verified opening correctly, page must be open in browser
		@doc = Nokogiri::XML(open("https://s3.amazonaws.com/abodo-misc/sample_abodo_feed.xml"))
		
		@propertiesArray = Array.new
		# This should give a nodelist of all Property nodes that have a City descendent somewhere with
		# the text value = 'Madison'
		# Now verified that it returns this, checked number of nodes in the list and it was the 
		# correct value.
  		@properties = @doc.xpath("//Property[descendant::City[text()='Madison']]")
  	
  		# Now, want to take info from each node and make a Property object out of it to add to the 
  		# propertiesArray of Propery objects
  		@properties.each do |node|
  			# These three do not throw errors now
  			newID = node.at_xpath(".//Identification/@IDValue").value
  			newName = node.xpath(".//MarketingName").text
  			newEmail = node.xpath(".//Email").text
  			# Make a new Property object using these values, no errors now
  			@newProperty = Property.new(newID, newName, newEmail)
  			# Add this new Property to the array of Properties initialized earlier, no errors
  			@propertiesArray << @newProperty
  		end
  		
  		render template: 'scrape_properties'
	end
end
