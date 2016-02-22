# Curse Client

Curse Client is a command line client for curse-hosted Minecraft modpacks.

## Prerequisites

You must have Ruby 1.9.3 or greater installed.
https://www.ruby-lang.org/en/documentation/installation/

## Installation

Install the gem.

    $ gem install curse_client

## Usage

### Help

Get a list of commands

    $ curse help

### List
List all modpacks

    $ curse list

### Search

Search for a modpack

    $ curse search "<regexp>"

Example:

    $ curse search "ftb"

    FTB Departed: Travel to distant worlds and dimensions, encounter ghoulish and strange creatures, and craft legendary tools and equipment in...
    FTB Horizons: Created to showcase some lesser-known 1.6.4 mods in the Minecraft world that don’t often get put into larger packs. You’ve ce...
    FTB Horizons: Daybreaker: Daybreaker is the sequel to the original Horizons, but updated and remastered for 1.7.10. It aims to show off new mods to the...
    FTB Infinity Evolved: Infinity Evolved adds game modes!  Two modes are currently included; 'normal' and 'expert'.  New and existing worlds are auto...
    FTB Lite: A lightweight, simple-to-use 1.4.7 modpack designed for both users who are either unfamiliar with  mods or those with compute...
    --- snip ---

### Show

Show details for a modpack

    $ curse show "<modpack name>"

Example:

    $ curse show "FTB Infinity Evolved"
    FTB Infinity Evolved
    Summary: Infinity Evolved adds game modes!  Two modes are currently included; 'normal' and 'expert'.  New and existing worlds are auto...
    Authors: FTB, FTBTeam
    Url: http://www.curse.com/modpacks/minecraft/227724-ftb-infinity-evolved
    Categories: Exploration, Extra Large, FTB Official Pack, Magic, Tech
    Downloads: 602881.0
    Popularity: 5792.97021484375
    Files:
        2283980    2016-02-26T17:02:28    1.7.10    FTBInfinity-2.4.1-1.7.10.zip (Beta)
        2283863    2016-02-25T22:22:09    1.7.10    FTBInfinity-2.4.0-1.7.10.zip (Beta)
        2275596    2016-01-15T17:42:51    1.7.10    FTBInfinity-2.3.5-1.7.10.zip (Release)
        2275249    2016-01-13T21:03:15    1.7.10    FTBInfinity-2.3.4-1.7.10.zip (Beta)
        2273009    2015-12-30T21:12:24    1.7.10    FTBInfinity-2.3.3-1.7.10.zip (Beta)
        2272982    2015-12-30T19:22:22    1.7.10    FTBInfinity-2.3.2-1.7.10.zip (Beta)

### Install

Install the specified modpack.

    $ curse install "<modpack name>" [path] [options]

Options:
`--version <version>`: `<version>` can be one of
- release: The latest release version (default)
- latest: The latest version, including betas
- file id: The id of the file
- file date: The date of the file
- file name: The name of the file

Example:

    $ curse install "FTB Infinity Evolved" "/Users/amcoder/Applications/MultiMC/instances/Infinity/minecraft" --version latest
    Installing FTB Infinity Evolved
    Downloading http://addons.curse.cursecdn.com/files/2226/936/FTBInfinity-1.0.0-1.7.10.zip 100%
    Downloading http://addons.curse.cursecdn.com/files/2225/549/AOBD-2.4.0.jar  100%
    Downloading http://addons.curse.cursecdn.com/files/2225/85/AgriCraft-1.7.10-1.2.1.jar  100%
    Downloading http://addons.curse.cursecdn.com/files/2219/248/Aroma1997Core-1.7.10-1.0.2.13.jar  100%
    -- snip --
    Installed FTB Infinity Evolved to /Users/amcoder/Applications/MultiMC/instances/Infinity/minecraft
    Requires minecraft 1.7.10 and forge-10.13.2.1291

### MultiMC Install

1. Create a new MultiMC instance for the required minecraft version
2. Run `curse install "<modpack name>" "<MultiMC instance folder>/minecraft"`
3. Install the specified version of forge in your instance
4. Play! :)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake spec` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/amcoder/curse_client.


## License

The gem is available as open source under the terms of the
[MIT License](http://opensource.org/licenses/MIT).
