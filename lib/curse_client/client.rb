require 'fileutils'
require 'zip'
require 'pstore'

module CurseClient
  class Client

    HOME_DIR = "#{Dir.home}/.curse_client"
    CACHE_DIR = "#{HOME_DIR}/cache"

    def initialize(feed = CurseClient::Feed.new, api = CurseClient::API.new)
      @feed = feed
      @api = api

      FileUtils::mkpath(CACHE_DIR)

      api.token = token
    end

    def projects
      @projects ||= load_projects
    end

    def modpacks
      projects.
        select { |d| d[:category_section] == :modpacks }.
        sort_by { |d| d[:name] }
    end

    def find_by_name(name)
      modpack = modpacks.
        select { |m| m[:name] == name }.
        first
      addon(modpack[:id])
    end

    def addon(id)
      with_authentication do
        api.addon(id)
      end
    end

    def addon_files(addon_id)
      with_authentication do
        api.addon_files(addon_id)[:files].
          sort_by{|f| f[:file_date] }.
          reverse
      end
    end

    def addon_file(addon_id, file_id)
      with_authentication do
        api.addon_file(addon_id, file_id)
      end
    end

    def install(modpack, path, version)
      Installer.new(self).install(modpack, path, version)
    end

    private

    attr_reader :feed,
                :api

    def with_authentication
      yield
    rescue API::UnauthorizedError
      retry if authenticate
    end

    def authenticate
      print "Curse username: "
      username = $stdin.gets.chomp
      print "Curse Password: "
      password = $stdin.noecho(&:gets).chomp
      puts ""
      api.authenticate(username, password)
      self.token = api.token
      true
    rescue API::UnauthorizedError
      puts "Inavlid username or password"
      false
    end

    def load_projects
      puts "Loading project information from curse"

      store = load_store

      if store[:complete_timestamp] < feed.complete_timestamp
        complete = feed.complete
        store[:complete_timestamp] = complete[:timestamp]
        store[:projects] = strip_data(complete[:data])
        save_store(store)
      end

      store[:projects]
    end

    def strip_data(data)
      data.map do |project|
        {
          id: project[:id],
          name: project[:name],
          summary: project[:summary],
          category_section: project[:category_section][:name].downcase.gsub(/ /, "_").to_sym,
        }
      end
    end

    def load_store
      store = PStore.new("#{CACHE_DIR}/projects.pstore")
      store.transaction(true) do
        {
          complete_timestamp: store[:complete_timestamp] || 0,
          projects: store[:projects]
        }
      end
    end

    def save_store(data)
      store = PStore.new("#{CACHE_DIR}/projects.pstore")
      store.transaction do
        store[:complete_timestamp] = data[:complete_timestamp]
        store[:projects] = data[:projects]
      end
    end

    def token
      @token ||=
        begin
          store = PStore.new("#{HOME_DIR}/token.pstore")
          store.transaction(true) do
            store[:token]
          end
        end
    end

    def token=(t)
      store = PStore.new("#{HOME_DIR}/token.pstore")
      store.transaction do
        store[:token] = t
      end
    end
  end
end
