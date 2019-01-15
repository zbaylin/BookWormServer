module BookWormServer
  post "/api/issuance/create" do |env|
    begin
      required_params = ["email", "password", "isbn"]
      require_json_params(required_params, env)

      if !Student.authenticate(
        env.params.json["email"].as(String),
        env.params.json["password"].as(String)
      )
        response = {"success": false, "message": "Incorrect user credentials."}.to_json
        halt env, status_code: 403, response: response
      end

      student = Repo.get_by!(Student, email: env.params.json["email"].as(String))
      book = Repo.get_by!(Book, isbn: env.params.json["isbn"].as(String))

      issuance = Issuance.new
      issuance.student_id = student.id
      issuance.book_id = book.id
      cs = Repo.insert(issuance)
      cs.valid? ? nil : raise "DB Error"

      {"success": true, "issuance": issuance}.to_json
    rescue exception
      response = {"success": false, "message": "Unable to create issuance: #{exception}"}.to_json
      halt env, status_code: 500, response: response
    end
  end
end