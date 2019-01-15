module BookWormServer
  # We define our issuance model class...
  class Issuance < Crecto::Model
    schema "students" do
      # ...each of which has a:
      field :redemption_key, String # Redemption key

      # ...each of which belongs to a:
      belongs_to :student, Student # Student
      belongs_to :book, Book # Book
    end
  end
end