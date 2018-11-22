#### Main API routes file
# The API handles all the routes which
# allow the desktop application to interface
# with the server.

# We import all the other API routes, such as:
require "./books.cr" # The books API

module BookWormServer

  # We know all the API responses will be in JSON,
  # so before all API requests, set the response
  # type to JSON.
  before_all "/api/*" do |env|
    env.response.content_type = "application/json"
  end
  
end