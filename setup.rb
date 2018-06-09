#!/usr/bin/env ruby

require 'fileutils'
require 'pathname'

$USER_HOME_PATH = Pathname.new(ENV['HOME'])
$DOTFILES_PATH = $USER_HOME_PATH + '/dotfiles'

def setup_dotfiles
  FileUtil.mkdir_p($DOTFILES_PATH)
end

#--- Main

setup_dotfiles
