module CurseClient
  class Installer
    def initialize(client)
      @client = client
    end

    def install(modpack, path, version)
      modpack_file = find_file(modpack, version)
      unless modpack_file
        puts "Could not find #{modpack[:name]} version #{version}"
        return
      end

      puts "Installing #{modpack[:name]}"
      file = download(modpack_file[:download_url])

      path = File.expand_path(path)
      FileUtils::mkpath(path) unless File.exists?(path)
      unless File.directory?(path)
        puts "#{path} is not a directory"
        return
      end

      manifest = unzip(file, path)
      download_mods(manifest, path)
      write_configuration(path, modpack, modpack_file)

      puts "\nInstalled #{modpack[:name]} to #{File.expand_path(path)}"
      puts "Requires minecraft #{manifest["minecraft"]["version"]} and #{manifest["minecraft"]["modLoaders"][0]["id"]}"
    end

    private

    attr_reader :client

    def find_file(modpack, version)
      client.addon_files(modpack[:id]).
        select{|f| file_eligible?(f, version) }.
        first
    end

    def file_eligible?(file, version)
      case version
      when "release"
        file[:release_type] == "Release"
      when "latest"
        true
      else
        file[:id].to_s == version ||
          file[:file_date] == version ||
          file[:file_name] =~ /\A#{version}/
      end
    end

    def unzip(file, path)
      Zip::File.open(file) do |zip|
        # manifest
        entry = zip.find_entry('manifest.json')
        manifest = entry.get_input_stream do |stream|
          JSON.parse(stream.read.gsub("\r", "").gsub("\n", ""))
        end
        overrides_name = manifest["overrides"]

        # extract
        zip.each do |entry|
          file_path = "#{path}/#{entry.name.gsub(/\A#{overrides_name}\//, "")}"
          entry.extract(file_path) { true }
        end
        manifest
      end
    end

    def download_mods(manifest, path)
      modpath = "#{path}/mods"
      FileUtils.mkpath(modpath)
      manifest["files"].each do |manifest_mod|
        mod_file = client.addon_file(manifest_mod["projectID"], manifest_mod["fileID"])
        file = download(mod_file[:download_url])
        FileUtils.copy(file, modpath)
      end
    end

    def write_configuration(path, modpack, modpack_file)
      File.open("#{path}/curse_client.json", "w+") do |file|
        file << JSON.pretty_generate({
          id: modpack[:id],
          name: modpack[:name],
          file: modpack_file
        })
      end
    end

    def download(url)

      uri = URI.parse(escape(url))
      path = "#{Client::CACHE_DIR}/#{uri.host}/#{URI.unescape(uri.path)}"

      print "Downloading #{url}     "
      unless File.exists?(path)
        downloader = CurseClient::Downloader.new
        downloader.fetch(uri, path) do |progress|
          print "\b\b\b\b% 3d%%" % progress
        end
      end
      puts "\b\b\b\b100%"

      path
    end

    def escape(url)
      URI.escape(URI.escape(url), "[]")
    end

  end
end
