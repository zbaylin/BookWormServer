#### Welcome to BookWormServer!
# This is the main file that is executed
# which imports all the other routes, models,
# config data, etc. and runs the Kemal
# server itself. Let's get started!

# Imports the libraries we need, such as:
require "kemal" # Kemal -- see kemalcr.com
require "kemal-session" # kemal-session -- see github.com/kemalcr/kemal-session
require "sqlite3" # SQLite3 -- part of Crystal's standard library
require "crecto" # Crecto -- see crecto.com
require "crypto/bcrypt/password" # bcrypt -- from the stdlib, used for password encryption

# Imports all the files we have written, such as:
require "./models/main.cr" # The main models file
require "./routes/main.cr" # The main routes file

# Imports all the utilities, such as:
require "./utils/routing.cr" # The tools helping with routing

module BookWormServer
  VERSION = "1.0.0"

  # Run the Kemal server
  Kemal.run
end