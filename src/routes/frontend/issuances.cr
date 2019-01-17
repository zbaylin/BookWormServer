module BookWormServer
  get "/issuance/redeem" do |env|
    components = ["Redeem"]
    render "src/views/redeem.slang", "src/views/layout.slang"
  end

  get "/issuance/download/:url" do |env|
    begin
      issuance_query = Query.where(url: env.params.url["url"].as(String))
                            .preload(:book)
      issuance = Repo.all(Issuance, issuance_query)[0].as(Issuance)

      send_file env, "data/ebooks/#{issuance.book.isbn}.pdf", "application/pdf"
    rescue exception
      components = [] of String
      message = "There has been an error retrieving your eBook: #{exception}"
      render "src/views/error.slang", "src/views/layout.slang"
    end
  end
end