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
      field :grade, String # Grade

      has_many :issuances, Issuance # many Issuances
      has_many :books, Book, through: :issuances

      unique_constraint :email # The email is unique, so 1 account per student.
    end

    # Create a method to authenticate if a student's credentials are valid
    def self.authenticate(email : String, password : String)
      student = Repo.get_by(Student, email: email)
      if (student == nil)
        return false
      end
      student = student.as(Student)
      return Crypto::Bcrypt::Password.new(student.password.as(String)) == password
    end

    def self.backup
      students = Repo.all(Student)
      CSV.build do |csv|
        csv.row ["First name", "Last name", "Email", "Grade"]
        students.each do |student|
          csv.row [
            student.firstname,
            student.lastname,
            student.email,
            student.grade
          ]
        end
      end
    end
    
  end
end