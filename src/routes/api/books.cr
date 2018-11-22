#### Books API routes

module BookWormServer
  get "/api/books" do |env|
    begin
      books = Repo.all(Book)
      {"success": true, "books": books}.to_json
    rescue exception
      response = {"success": false, "message": "Unable to retrieve books: #{exception}"}.to_json
      halt env, status_code: 500, response: response
    end
  end
end