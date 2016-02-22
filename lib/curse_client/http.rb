require 'net/http'

module CurseClient
  class HTTP

    def self.get(uri, options = {}, &block)
      uri = create_uri(uri)
      request = Net::HTTP::Get.new(uri.request_uri)
      request.initialize_http_header(options[:headers]) if options[:headers]
      send_request(uri, request, &block)
    end

    def self.post(uri, body, options = {}, &block)
      uri = create_uri(uri)
      request = Net::HTTP::Post.new(uri.request_uri)
      request.initialize_http_header(options[:headers]) if options[:headers]
      request.body = parse_request_body(body, options[:format] || :json)
      send_request(uri, request, &block)
    end

    private

    def self.create_uri(uri)
      return uri if uri.is_a?(URI)
      URI.parse(uri)
    end

    def self.parse_request_body(body, format)
      case format
      when :json
        JSON.generate(body)
      else
        raise NotImplementedError, "Format #{format} is not implemented"
      end
    end

    def self.send_request(uri, request)
      Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == "https") do |http|
        return http.request(request) do |response|
          yield response if block_given?
        end
      end
    end
  end
end
