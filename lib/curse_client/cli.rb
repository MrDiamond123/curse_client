require 'thor'
require 'curse_client'

module CurseClient
  class CLI < Thor

    desc "list", "List the available modpacks"
    def list
      client.modpacks.each do |modpack|
        puts simple_description(modpack)
      end
    end

    desc "search <regexp>", "Search for a modpack"
    def search(regexp)
      client.modpacks.
        select { |m| m[:name] =~ /#{regexp}/i }.
        each { |m| puts simple_description(m) }
    end

    desc "show <modpack>", "Show details for a modpack"
    def show(modpack_name)
      modpack = client.find_by_name(modpack_name)

      if modpack
        puts modpack[:name]
        puts "Summary: #{modpack[:summary]}"
        puts "Authors: #{modpack[:authors].map{|a| a[:name]}.join(", ")}"
        puts "Url: #{modpack[:web_site_url]}"
        puts "Categories: #{modpack[:categories].map{|c| c[:name]}.join(", ")}"
        puts "Downloads: #{modpack[:download_count]}"
        puts "Popularity: #{modpack[:popularity_score]}"
        puts "Files:"
        client.addon_files(modpack[:id]).each do |f|
          puts "   #{f[:id]}    #{f[:file_date]}    #{f[:game_version].first}    #{f[:file_name]} (#{f[:release_type]})"
        end
      else
        puts "Cannot find modpack #{modpack_name}"
      end
    end

    desc "install <modpack> [path] [options]", "Install the modpack to [path]"
    option :version, alias: "-v", default: "release",
                     desc: "One of 'latest', 'release', file id, file date, or file name"
    def install(modpack_name, path = modpack_name)
      modpack = client.find_by_name(modpack_name)
      if modpack
        client.install(modpack, path, options[:version])
      else
        puts "Cannot find modpack #{modpack_name}"
      end
    end

    private

    def simple_description(modpack)
      "#{modpack[:name]}: #{modpack[:summary]}"
    end

    def client
      @client ||= CurseClient::Client.new
    end
  end
end
