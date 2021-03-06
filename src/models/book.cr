module BookWormServer
  # We define our book model class...
  class Book < Crecto::Model
    set_created_at_field nil
    set_updated_at_field nil

    schema "books" do
      # ...each of which has a(n):
      field :isbn, String # ISBN -- a global book identifier
      field :title, String # Title
      field :author, String # Author
      field :publisher, String # Publisher
      field :summary, String # Summary
      field :publication_date, Time # Publication Date
      field :rating, Float64 # Rating
    end

    def self.backup
      books = Repo.all(Book)
      CSV.build do |csv|
        csv.row ["ISBN", "Title", "Author", "Publisher", "Summary", "Publication Date", "Rating"]
        books.each do |book|
          csv.row [
            book.isbn,
            book.title,
            book.author,
            book.publisher,
            book.summary,
            book.publication_date,
            book.rating
          ]
        end
      end
    end

  end
end