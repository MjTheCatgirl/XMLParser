Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # Display this action in browser as our homepage
  root 'application#scrape_properties'

end
