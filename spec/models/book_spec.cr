require "../spec_helper.cr"

Book = BookWormServer::Book

describe BookWormServer::Book do
  it "retrieves books from the database" do
    books = Repo.all(Book)
    books[0].should be_a(BookWormServer::Book)
  end
end