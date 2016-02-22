require 'bzip2/ffi'
require 'open-uri'
require 'json'

module CurseClient
  class Feed

    DEFAULT_URL = "http://clientupdate-v6.cursecdn.com/feed/addons/432/v10/"
    COMPLETE_URL = DEFAULT_URL + "complete.json.bz2"
    HOURLY_URL = DEFAULT_URL + "hourly.json.bz2"

    def initialize(url = DEFAULT_URL)
      @url = url
    end

    def hourly_timestamp
      get_timestamp(HOURLY_URL)
    end

    def hourly
      download_bz2(HOURLY_URL + "?t=#{hourly_timestamp}")
    end

    def complete_timestamp
      get_timestamp(COMPLETE_URL)
    end

    def complete
      download_bz2(COMPLETE_URL)
    end

    private

    attr_reader :url

    def download_bz2(url)
      open(COMPLETE_URL) do |request|
        Bzip2::FFI::Reader.open(request) do |bz2|
          fix_keys(JSON.parse(bz2.read))
        end
      end
    end

    def get_timestamp(url)
      open(url + ".txt") do |request|
        Integer(request.read)
      end
    end

    def fix_keys(value)
      case value
      when Array
        value.map{ |v| fix_keys(v) }
      when Hash
        Hash[value.map { |k, v| [underscore(k).to_sym, fix_keys(v)] }]
      else
        value
      end
    end

    def underscore(name)
      return name.downcase if name.match(/\A[A-Z]+\z/)
      name.
        gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2').
        gsub(/([a-z])([A-Z])/, '\1_\2').
        downcase
    end
  end
end
