#!/usr/bin/ruby

#  _     ___  _       ___ _ __  __   ____    _    ____       _  _____ 
# | |   / _ \| |     |_ _( )  \/  | | __ )  / \  |  _ \     / \|_   _|
# | |  | | | | |      | ||/| |\/| | |  _ \ / _ \ | | | |   / _ \ | |  
# | |__| |_| | |___   | |  | |  | | | |_) / ___ \| |_| |  / ___ \| |  
# |_____\___/|_____| |___| |_|  |_| |____/_/   \_\____/  /_/   \_\_|  
#                                                                     
#  ____  _   _ ______   __
# |  _ \| | | | __ ) \ / /
# | |_) | | | |  _ \\ V / 
# |  _ <| |_| | |_) || |  
# |_| \_\\___/|____/ |_|  
                        
require 'fileutils'
include FileUtils

files = [
  '_ackrc',
  '_bash_profile',
  '_gitconfig',
  '_gitignore_global',
  '_tmux.conf',
]

class ConfigFile

  def install (file)
    if exists? file
      destFile = file.sub('_', '.')
      puts "Looks like #{destFile} already exists. Backing it up."
      backup file
    end

    link file
  end

  private

  def exists? (file)
    # Check if given config exists
    homeDir = ENV['HOME']
    destFile = file.sub('_', '.')

    File.exists?( "#{homeDir}/#{destFile}" )
  end

  def backup (file)
    # Back up existing config
    homeDir = ENV['HOME']
    destFile = file.sub('_', '.')
    oldFile = "#{homeDir}/#{destFile}"
    timestamp = Time.new.strftime('%H-%M-%S')
    mv(oldFile, "#{oldFile}_#{timestamp}")
  end

  def link (file)
    # Link config into place
    homeDir = ENV['HOME']
    destFile = file.sub('_', '.')
    currentDir = Dir.pwd
    ln_s("#{currentDir}/#{file}", "#{homeDir}/#{destFile}")
  end
end

files.each { |file|
  ConfigFile.new.install file
}
