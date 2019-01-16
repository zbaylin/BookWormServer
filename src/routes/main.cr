#### Main routes file
# A route is a URI path exposed to the internet.
# Kemal uses a radix implementation to find the
# path and match it to a route.

# We import all other relevant routes, such as:
require "./api/main.cr" # The main API routes file
require "./frontend/main.cr" # The main frontend routes file

module BookWormServer
end