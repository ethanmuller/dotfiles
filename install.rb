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
  '_zshrc',
  '_gitconfig',
  '_gitignore_global',
  '_tmux.conf',
]

class String
  # colorization
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end

  def yellow
    colorize(33)
  end

  def cyan
    colorize(36)
  end
end

class Linker
  def safeLink (file)
    puts "Linking #{full_file(file)}"

    if File.exists?(dest_file(file))
      backup dest_file(file)
    end

    link file
  end

  def link (file)
    ln_s(full_file(file), dest_file(file))

    puts "Linked #{dest_file(file)} -> #{full_file(file)}\n".cyan
  end

  def backup (file)
    timestamp = '_' + Time.new.strftime('%H-%M-%S')

    new_name = file + timestamp

    mv(file, new_name)

    puts "Backed up #{file} to #{new_name}".yellow
  end

  def install_dir
    File.expand_path('~') + '/'
  end

  def dest_name (file)
    # The name a file will have
    # in its installed destination
    if file[0] == '_'
      file = file.sub('_', '.')
    end

    if file == '.'
      # This directory is being linked
      file = '.vim'
    end

    return file
  end

  def dest_file (file)
    install_dir + dest_name(file)
  end

  def full_file (file)
    File.expand_path(file)
  end
end

files.each { |file|
  Linker.new.safeLink file
}
