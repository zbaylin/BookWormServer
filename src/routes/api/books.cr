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

  get "/api/book/:isbn/info" do |env|
    begin
      # Make a shortcut to the URL ISBN parameter
      isbn = env.params.url["isbn"]
      # Get the book from the database by its ISBN
      book = Repo.get_by(Book, isbn: isbn)

      # See if the book exists:
      # If it's nil, then it doesn't exist
      if book == nil
        # Prepare a response with the error
        response = {"success": false, "message": "Book with isbn #{isbn} does not exist."}.to_json
        # Halt the environment with an error code and send the response
        halt env, status_code: 404, response: response
      end
      # Cast the book to a Book object
      book = book.as(Book)
      {"success": true, "book": book}.to_json
    rescue exception
      # Prepare a response with the error
      response = {"success": false, "message": "Unable to retrieve book: #{exception}"}.to_json
      # Halt the environment with an error code and send the response
      halt env, status_code: 500, response: response
    end
  end

  get "/api/book/:isbn/cover_image" do |env|
    begin
      # Make a shortcut to the URL ISBN parameter
      isbn = env.params.url["isbn"].as(String)
      # If a cover file exists, set the path to it. Else, just set it to the default.
      path = File.exists?("data/thumbs/" + isbn) ? "data/thumbs/" + isbn : "data/thumbs/default"
      # Send the file at the path
      send_file env, path
    rescue exception
      send_file env, "data/thumbs/default"
    end 
  end
end