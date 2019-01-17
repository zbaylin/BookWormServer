module BookWormServer
  # We define our issuance model class...
  class Issuance < Crecto::Model
    schema "issuances" do
      # ...each of which has a:
      field :redemption_key, String, # Redemption key
        default: Random.new.base64(6)
      field :redeemed, Bool, # Redemption state
        default: false
      field :url, String # URL  

      # ...each of which belongs to a:
      belongs_to :student, Student # Student
      belongs_to :book, Book # Book
    end
  end
end