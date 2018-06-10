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
    git_configure
  end

  def sync!
    if git_tracked?(@path)
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
    git_run("reset --hard origin/ft-setup-script")
    git_run("clean -fd")
    git_run("pull")
  end

  def git_tracked?(path)
    path = Pathname.new(path)
    unless Dir.exists?(path)
      return false
    end
    git_dir = path + '.git'
    unless Dir.exists?(git_dir)
      return false
    end
    return true
  end

  def git_run(str)
    command = "cd #{@path} && #{@git_com} #{str}"
    puts "git_run. command: #{command}"
    system(command)
  end

  def git_configure
    @git_com = git_install
    unless @git_com
      raise "Program git could not be found"
    end
    puts "--- git_com = #{@git_com}"
  end

  def git_install
    if com?("git")
      puts "git already installed"
      return `which git`.chomp
    end
    if com?("apt-get")
      puts "--- installing git via apt-get"
      `system apt-get install git`
      return `which git`.chomp
    else
      puts "--- FATAL. you must install git"
      return nil
    end
  end

  def com?(com)
    system("which #{com}")
    return $?.exitstatus == 0
  end

end

class FileTree
  require 'find'
  require 'pathname'

  def initialize(path)
    path = Pathname.new(path)
    @path = path + 'tree'
  end

  def sync!
    Find.find(@path.to_s) do |path|
      next if File.directory?(path)

      npath = path.clone.to_s
      npath = npath.gsub(/^#{@path}\//, '')
      npath = npath.gsub(/^__HOME__/, $USER_HOME_PATH.to_s)
      npath = npath.gsub(/^__ROOT__/, '/')
      npath = npath.gsub(/\/+/, '/')

      npath_base = File.basename(npath)
      next if npath_base == '.keep'
      print "#{npath} ==> #{path}"

      if File.exists?(npath)
        npath_lstat = File.lstat(npath)
        if npath_lstat.symlink? && (npath_target = File.readlink(npath)) && (npath_target == path)
          puts " --- SKIPPED. Already Symlinked"
          next
        else
          puts
          backup(npath)
        end
      else
        puts
      end

      FileUtils.mkdir_p(File.dirname(npath))
      FileUtils.ln_sf(path, npath)
    end
  end

  def backup(path)
    return unless File.exists?(path)
    bpath = path + ".bck_#{Time.now.to_i}"
    FileUtils.mv(path, bpath)
  end

end

#--- Main
dot_gtr = GitTrackedRepo.new($DOTFILES_REPO, $DOTFILES_PATH)
dot_gtr.sync!

#--- --- Safely symlink files
ft = FileTree.new($DOTFILES_PATH)
ft.sync!

#--- --- Setup VIM
