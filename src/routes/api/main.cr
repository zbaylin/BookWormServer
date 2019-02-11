#### Main API routes file
# The API handles all the routes which
# allow the desktop application to interface
# with the server.

# We import all the other API routes, such as:
require "./books.cr" # The books API
require "./students.cr" # The students API
require "./issuances.cr" # The issuances API -- allows users to check out eBooks

module BookWormServer

  # We know all the API responses will be in JSON,
  # so before all API requests, set the response
  # type to JSON.
  before_all "/api/*" do |env|
    env.response.content_type = "application/json"
  end

  get "/api/backup.zip" do |env|
    env.response.content_type = "application/zip"
    path = ""
    File.tempfile("backup", ".zip") do |file|
      path = file.path
      Zip::Writer.open(file) do |zip|
        zip.add "books.csv", Book.backup
        zip.add "students.csv", Student.backup
      end
    end
    send_file env, path
  end
end