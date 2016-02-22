module CurseClient
  class API

    class UnauthorizedError < StandardError; end

    DEFAULT_URL = "https://curse-rest-proxy.azurewebsites.net/api"

    attr_accessor :token

    def initialize(url = DEFAULT_URL)
      @url = url
    end

    def authenticated?
      !token.nil?
    end

    def authenticate(username, password)
      response = HTTP.post("#{url}/authenticate",
                            { username: username, password: password },
                            headers: { "Content-Type" => "application/json" },
                            format: :json)
      case response
      when Net::HTTPUnauthorized
        raise UnauthorizedError, "Invalid username or password"
      when Net::HTTPSuccess
        data = JSON.parse(response.body, symbolize_names: true)
        @token = "#{data[:session][:user_id]}:#{data[:session][:token]}"
      else
        response.error!
      end
    end

    def addon(id)
      get_json("addon/#{id}")
    end

    def addon_files(id)
      get_json("addon/#{id}/files")
    end

    def addon_file(addon_id, file_id)
      get_json("addon/#{addon_id}/file/#{file_id}")
    end

    private

    attr_reader :url

    def get_json(path)
      response = HTTP.get("#{url}/#{path}",
                           headers: { "Authorization" => "Token #{token}" })
      case response
      when Net::HTTPUnauthorized
        raise UnauthorizedError, "Invalid token"
      when Net::HTTPSuccess
        return JSON.parse(response.body, symbolize_names: true)
      else
        response.error!
      end
    end
  end
end
