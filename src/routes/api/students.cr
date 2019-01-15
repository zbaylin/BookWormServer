#### Student API routes file
# This file handles all API methods
# related to student objects

module BookWormServer
  # Create a route that lets a user create a student
  post "/api/student/create" do |env|
    begin
      # Create a new student object...
      student = Student.new
      # ...and assign the params:
      student.email = env.params.json["email"].as(String) # Email
      student.password = Crypto::Bcrypt::Password.create(env.params.json["password"].as(String)).to_s # Password
      student.firstname = env.params.json["firstname"].as(String) # Firstname
      student.lastname = env.params.json["lastname"].as(String) # Lastname
      # Insert the student
      cs = Repo.insert(student)
      # If the insertion is invalid, raise a DB Error
      cs.valid? ? nil : raise "DB Error"

      # Give the user feedback that it was successful
      {"success": true}.to_json
      
    # If it's not successful...
    rescue exception
      # ...prepare a response...
      response = {"success": false, "message": "Unable to create user: #{exception}"}.to_json
      # ...and send it.
    end
  end
end