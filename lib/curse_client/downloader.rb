require 'tempfile'

module CurseClient
  class Downloader

    class DownloadError < StandardError; end

    def fetch(uri, path, &block)
      HTTP.get(uri) do |response|
        case response
        when Net::HTTPSuccess
          save_response(response, path, &block)
        when Net::HTTPRedirection
          url = URI.escape(response['location'], "[]")
          return fetch(url, path, &block)
        else
          response.error!
        end
      end
    rescue Exception => e
      raise DownloadError, e.message
    end

    private

    attr_reader :logger

    def save_response(response, path)
      length = response['Content-Length'].to_i
      done = 0

      FileUtils.mkpath(File.dirname(path))
      temp_file_name = "#{path}.#{Time.now.to_f}"
      File.open(temp_file_name, "w+") do |file|
        response.read_body do |chunk|
          file << chunk
          done += chunk.length
          progress = (done.quo(length) * 100).to_i
          yield progress if block_given?
        end
      end

      FileUtils.move(temp_file_name, path)
    ensure
      FileUtils.remove(temp_file_name) if File.exists?(temp_file_name)
    end
  end
end
