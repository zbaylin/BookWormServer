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
      student.grade = env.params.json["grade"].as(String) # Grade
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
      halt env, status_code: 500, response: response
    end
  end

  get "/api/students" do |env|
    begin
      student_query = Query.preload(:issuances)
      students = Repo.all(Student, student_query)
      {"success": true, "students": students}.to_json
    rescue exception
      response = {"success": false, "message": "Unable to get users: #{exception}"}.to_json
      halt env, status_code: 500, response: response
    end
  end

  post "/api/student/edit" do |env|
    begin
      student = Repo.get_by(Student, id: env.params.json["id"].as(Int64))
      if student == nil
        raise "Student not found."
      end

      student = student.as(Student)
      student.firstname = env.params.json["firstname"].as(String)
      student.lastname = env.params.json["lastname"].as(String)
      student.email = env.params.json["email"].as(String)
      student.grade = env.params.json["grade"].as(String)
      changeset = Repo.update(student)
      if !changeset.valid?
        raise "DB Error"
      end

      {"success": true}.to_json
    rescue exception
      response = {"success": false, "message": "Unable to edit student: #{exception}"}.to_json
      halt env, status_code: 500, response: response
    end
  end
end