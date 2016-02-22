require 'curse_client'

module CurseClient
  class CLI
    def self.start(*args)
      puts "Curse Downloader v#{CurseClient::VERSION}"
    end
  end
end
