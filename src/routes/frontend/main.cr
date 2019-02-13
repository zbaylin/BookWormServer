require "./issuances.cr"

module BookWormServer
  get "/" do |env|
    components = ["Index"] of String
    render "src/views/home.slang", "src/views/layout.slang"
  end 

  get "/download" do |env|
    components = [] of String
    render "src/views/download.slang", "src/views/layout.slang"
  end
end