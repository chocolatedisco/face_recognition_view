class HomeController < ApplicationController
  require 'base64'
  require 'net/http'
  require 'uri'
  require 'json'

  def home
  end

  def result
    if params[:file]
      #読み込みとb64化
      image = params[:file]
      b64 = Base64.encode64(image.read)

      #API問い合わせ
      uri = URI.parse("https://protected-lowlands-35272.herokuapp.com/readf")
      request = Net::HTTP::Post.new(uri)
      request.set_form_data(
        "sample" => b64,
      )

      req_options = {
        use_ssl: uri.scheme == "https",
      }

      response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
        http.request(request)
      end

      result = JSON.parse(response.body, quirks_mode: true)
      @like = result["name"]
      @face = result["iof"]
      @err = result["err"]
      @errme = result["errme"]
      
    end
  end

end