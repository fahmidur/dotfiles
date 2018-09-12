#!/usr/bin/env ruby

require 'fileutils'
require 'pathname'

$USER_HOME_PATH = Pathname.new(ENV['HOME'])
$DOTFILES_PATH = $USER_HOME_PATH + 'dotfiles'
$DOTFILES_TREE_META_PATH = $USER_HOME_PATH + '.dotfiles_tree_meta.json'
$DOTFILES_REPO = 'git@github.com:fahmidur/dotfiles.git'

class GitTrackedRepo
  require 'pathname'
  require 'fileutils'

  def initialize(repo, path)
    @repo = repo 
    @path = path
    git_configure
  end

  def sync!
    mydirpath = File.absolute_path(File.dirname(__FILE__))
    if mydirpath == @path.to_s
      puts "GitTrackedRepo. WARNING! Current directory is target path. sync SKIPPED."
      return
    end
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
    git_run("clean -fd")
    git_run("fetch --all")
    git_run("checkout -f master")
    git_run("reset --hard origin/master")
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
  require 'json'

  def initialize(path, meta_path)
    path = Pathname.new(path)
    @path = path + 'tree'
    @meta_path = meta_path
    unless @meta_path
      raise "meta_path required"
    end
    @meta_path = File.absolute_path(@meta_path)
    @meta_data = meta_read!
  end

  def meta_read!
    unless File.exists?(@meta_path)
      return {}
    end
    body = IO.read(@meta_path)
    data = nil
    begin
      data = JSON.parse(body)
    rescue => err
      puts "ERROR: Failed to parse meta data json"
      data = {}
    end
    return (@meta_data = data)
  end

  def meta_write!
    body = JSON.pretty_generate(@meta_data)
    meta_path_dirname = File.dirname(@meta_path)
    unless Dir.exists?(meta_path_dirname)
      FileUtils.mkdir_p(meta_path_dirname)
    end
    IO.write(@meta_path, body)
  end

  def sync!
    puts "\n"
    @meta_data['synced_at'] = Time.now.to_i

    puts "=== SYNC! Syncing ==="

    puts "\n"
    puts "=== SYNC! Checking previously linked files ..."
    linked = @meta_data['linked']
    linked.each do |source, data|
      target = data['target']
      print "#{target} "
      if File.exists?(target)
        puts "--- OK. Not Broken"
      else
        puts "--- LINK BROKEN. Removing"
        FileUtils.rm_f(target)
        meta_link_rem(source)
      end
    end

    puts "\n"
    puts "=== SYNC! Linking tree ..."
    Find.find(@path.to_s) do |path|
      next if File.directory?(path)

      npath = path.clone.to_s
      npath = npath.gsub(/^#{@path}\//, '')
      npath = npath.gsub(/^__HOME__/, $USER_HOME_PATH.to_s)
      npath = npath.gsub(/^__ROOT__/, '/')
      npath = npath.gsub(/\/+/, '/')

      npath_dirname = File.dirname(npath)
      npath_base = File.basename(npath)

      print "#{npath} ==> #{path}"
      if npath_base == '.keep'
        if File.directory?(npath_dirname)
          puts " --- SKIPPED. Directory already exists"
        else
          puts " --- Making directory"
          FileUtils.mkdir_p(npath_dirname)
        end
        next
      end

      if File.exists?(npath)
        npath_lstat = File.lstat(npath)
        if npath_lstat.symlink? && (npath_target = File.readlink(npath)) && (npath_target == path)
          puts " --- SKIPPED. Already Symlinked"
          meta_link_add(path, npath, :skipped)
          next
        else
          puts
          backup(npath)
        end
      else
        puts
      end

      meta_link_add(path, npath, :created)
      FileUtils.mkdir_p(npath_dirname)
      FileUtils.ln_sf(path, npath)
    end

    #puts "meta_data = #{@meta_data}"
    meta_write!
  end

  def meta_link_add(source, target, status)
    status = status.to_s
    @meta_data['linked'] ||= {}
    @meta_data['linked'][source] ||= {}
    merge_data = {
      'source' => source,
      'target' => target,
    }
    merge_data['history'] ||= {}
    merge_data['history'][status] = Time.now.to_i
    merge_data['history']['created'] ||= Time.now.to_i
    @meta_data['linked'][source].merge!(merge_data)
  end

  def meta_link_rem(source)
    status = status.to_s
    @meta_data['linked'] ||= {}
    @meta_data['linked'].delete(source)
  end

  def backup(path)
    return unless File.exists?(path)
    bpath = path + ".bck_#{Time.now.to_i}"
    FileUtils.mv(path, bpath)
  end

end

def run_command(str)
  puts "run_command: #{str}"
  system(str)
end

#--- Main
dot_gtr = GitTrackedRepo.new($DOTFILES_REPO, $DOTFILES_PATH)
dot_gtr.sync!

#--- --- Safely symlink files
ft = FileTree.new($DOTFILES_PATH, $DOTFILES_TREE_META_PATH)
ft.sync!
