#!/usr/bin/env ruby

require 'fileutils'
require 'pathname'
require 'pry'

$USER_HOME_PATH = Pathname.new(ENV['HOME'])
$DOTFILES_PATH = $USER_HOME_PATH + 'dotfiles'
$DOTFILES_REPO = 'https://github.com/fahmidur/dotfiles'

class GitTrackedRepo
  require 'pathname'
  require 'fileutils'

  def initialize(repo, path)
    @repo = repo 
    @path = path

  end

  def sync!
    git_install
    if Dir.exists?(@path)
      sync_again!
    else
      sync_first!
    end
  end

  private

  def sync_first!
    `git clone #{@repo} #{@path}`
  end

  def sync_again!
    git_com_at_path("reset --hard origin/master")
    git_com_at_path("git pull")
  end

  def git_com_at_path(str)
    `git --git-dir=#{@path}/.git #{str}`
  end

  def git_install
    if com?("git")
      puts "git already installed"
      return
    end
    if com?("apt-get")
      puts "--- installing git via apt-get"
      `system apt-get install git`
    else
      puts "--- FATAL. you must install git"
    end
  end

  def com?(com)
    system("which #{com}")
    return $?.exitstatus == 0
  end

end

def setup_dotfiles
  FileUtils.mkdir_p($DOTFILES_PATH)
  `git clone #{$DOTFILES_REPO} #{$DOTFILES_PATH}`
end

#--- Main

dot_gtr = GitTrackedRepo.new($DOTFILES_REPO, $DOTFILES_PATH)
dot_gtr.sync!
