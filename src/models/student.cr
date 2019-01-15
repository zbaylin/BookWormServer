module BookWormServer
  # We define our student model class...
  class Student < Crecto::Model
    set_created_at_field nil
    set_updated_at_field nil

    schema "students" do
      # ...each of which has a(n):
      field :firstname, String # First name
      field :lastname, String # Last name
      field :email, String # Email
      field :password, String # Password

      has_many :issuances, Issuance # and many Issuances.

      unique_constraint :email # The email is unique, so 1 account per student.
    end
  end
end