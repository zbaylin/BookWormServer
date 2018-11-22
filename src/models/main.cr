#### Main models file
# A model is a class representation of a real world
# object, like a book, person, checkout, etc.

# We import all the models in the project, such as:
require "./book.cr" # A book

module BookWormServer
  # We give the query and multi Crecto modules
  # shortcuts so we don't have to write them
  # out every time.
  Query = Crecto::Repo::Query
  Multi = Crecto::Multi

  # We define our own Repo module, which is an
  # abstraction in Crystal from the SQLite3 database...
  module Repo
    # ...which is an extension of the Crecto Repo module
    extend Crecto::Repo

    # We configure the Repo to our database...
    config do |conf|
      # ...which is SQLite3...
      conf.adapter = Crecto::Adapters::SQLite3
      # ...and can be found at this path
      conf.database = "./data/library.db"
    end
  end
end