#### Books API routes

module BookWormServer
  get "/api/books" do |env|
    books = Repo.all(Book)
    books.to_json
  end
end