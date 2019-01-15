module BookWormServer
  def self.require_json_params(required_params, env)
    required_params.each do |param|
      unless env.params.json.has_key?(param)
        response = {"success": false, "message": "Missing param '#{param}'"}.to_json
        halt env, status_code: 500, response: response
      end
    end
  end
end