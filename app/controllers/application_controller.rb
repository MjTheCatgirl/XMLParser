# Simple application controller that uses Nokogiri to scrape an XML document. The 
# document is an xml file representing various properties and their info. This controller
# finds all properties where the city is Madison. It then displays a list that for each 
# such property, shows its property id, it's name, and the email associated with it. 

class ApplicationController < ActionController::Base
	
	# Property class where each Property object represents a property from the xml document.
	# Each Property object is created containing only the attributes from the document that we
	# are interested in displaying. 
	class Property
    # This is used when creating a new property object with the new keyword. You must provide the
    # constructor with a property_id, name, and email upon creation.
    def initialize(property_id, name, email)
      @property_id = property_id
      @name = name
      @email = email
    end
    # Allows us to access the property_id attribute with dot notation in view
   def property_id
   	@property_id
   end
   # Allows us to access the name attribute with dot notation in view
   def name
   	@name
   end
   # Allows us to access the email attribute with dot notation in view
   def email
   	@email
   end
  end

	# This method does the work of for the controller class. It opens an XML document using 
	# Nokogiri. Then, it uses Xpath to return a nodeset of only property nodes where they City is
	# Madison. Using this list, for each node, xpath is used to extract the information we want to
	# display about that property. That information is used to construct a new Property object which
	# is added to an array of property objects, @propertiesArray. This array can then be used by our
	# view to iterate through the array of properties and display each attribute of each one. 
	# 
	# This works as expected for the provided XML file, just need to use view to display the info
	# properly
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
