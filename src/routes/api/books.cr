#### Books API routes

module BookWormServer
  get "/api/books" do |env|
    begin
      # Get all books from the database
      books = Repo.all(Book)
      # Return a successful request with the books in JSON
      {"success": true, "books": books}.to_json
    rescue exception
      # Prepare a response with the error
      response = {"success": false, "message": "Unable to retrieve books: #{exception}"}.to_json
      # Halt the environment with an error code and send the response
      halt env, status_code: 500, response: response
    end
  end
end