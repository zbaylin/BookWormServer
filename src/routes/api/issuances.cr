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

  post "/api/issuance/redeem" do |env|
    begin
      required_params = ["email", "password", "redemption_key"]
      require_json_params(required_params, env)
      
      if !Student.authenticate(
        env.params.json["email"].as(String),
        env.params.json["password"].as(String)
      )
        response = {"success": false, "message": "Incorrect user credentials."}.to_json
        halt env, status_code: 403, response: response
      end

      issuance_query = Query.where(redemption_key: env.params.json["redemption_key"].as(String))
                            .preload(:book)
      issuance = Repo.all(Issuance, issuance_query)[0].as(Issuance)

      if issuance.redeemed
        response = {"success": false, "message": "This issuance has already been redeemed."}.to_json
        halt env, status_code: 410, response: response
      end

      issuance.redeemed = true
      issuance.url = Random.new.urlsafe_base64

      Repo.update(issuance)

      isbn = issuance.book.isbn
      
      {"success": true, "url": issuance.url}.to_json
    rescue exception
      response = {"success": false, "message": "Unable to redeem issuance: #{exception}"}.to_json
      halt env, status_code: 500, response: response
    end
  end

  get "/api/issuances/weekly_stats" do |env|
    time_1 = Time.parse(env.params.query["date"].as(String), "%F", Time::Location::UTC)
    time_0 = time_1 - 7.days

    query = Query.where("date(created_at) BETWEEN ? AND ?", [time_0.to_s("%F"), time_1.to_s("%F")])
    issuances = Repo.all(Issuance, query)
    redeemed = issuances.count { |issuance| issuance.redeemed == true }

    {"success": true, "num_issuances": issuances.size, "num_redeemed": redeemed}.to_json
  end
end