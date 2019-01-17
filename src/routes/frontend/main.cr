require "./issuances.cr"

module BookWormServer
  get "/" do |env|
    components = ["Index"] of String
    render "src/views/home.slang", "src/views/layout.slang"
  end  
end