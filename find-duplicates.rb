#!/usr/bin/ruby

# Daneel Yaitskov

# this tool is written directly for 1 usecase.
# There is 2 folders containing relativly similar files
# but these files are in different pathes.
# And you need to merge to folder structures
# without space overhead.

# Solution. Merge file sets with cp or rsync.
# Start this script over 1 directory structure.
# Script builds hashes for all files.
# Groups pathes to files with the same hash.

require 'digest/md5'
require 'optparse'
require 'ruby-progressbar'

class PolicyLeaveLongest
  def choose_to_die(files)
    files.sort { |a,b| b.size - a.size }
  end
end

options = {
  :bar => lambda { |size| ProgressBar.create(:title => "Hashing",
                                             :format => '%t: %e %P |%b%i|',
                                             :total => size) },
  :dry => true,
  :remove_policy => PolicyLeaveLongest.new
}

class DummyBar
  def increment
  end
end

paths = []
begin
  OptionParser.new do |opts|
    opts.banner = 'Usage: find-duplicates.rb [ options ] <path-to-dir>'
    opts.on('-d', '--dry',
            'default. dry run. just show groups duplicated files 
                                      and which one will be left') do |v|
      options[:dry] = true
    end
    opts.on('-B', '--no-bar',
            'hide progress bar') do |v|
      options[:bar] = lambda { |size| DummyBar.new }
    end
    opts.on('-r', '--run',
            'delete duplicates by the specified policy') do |v|
      options[:dry] = false
    end
    opts.on('-l', '--longest',
            'policy leaves a file with longest name among duplicates') do |v|
      options[:remove_policy] = PolicyLeaveLongest.new
    end
  end.parse!

  if ARGV.empty?
    raise "there isn't any path given"  
  end

  paths = ARGV.map do |path|
    raise "path '#{ path }' isn't a directory" if !File.directory?(path)
    path.sub(/\/+ *$/, '')        
  end
rescue 
  $stderr.puts "Error #{ $! }"
  exit 1
end

class Groups
  def initialize
    @hashes = {}    
  end
  def add(path)
    md5 = Digest::MD5.new
    begin
      File.open(path, 'rb') do |file_h|
        file_h.each(8192) do |block|
          md5.update block
        end
      end
    rescue
      $stderr.puts "problem: #{ $! }"
      return
    end
    digest = md5.digest
    if @hashes.key?(digest)
      @hashes[digest] << path
    else
      @hashes[digest] = [ path ]
    end
  end
  def duplicates
    @hashes.find_all { |k,v| v.size > 1 }    
  end
end

groups = Groups.new
files = paths.map { |path| Dir.glob(path + '/**/*') }.flatten

bar = options[:bar].call files.size

files.each do |file|
  bar.increment
  next if File.directory?(file)
  groups.add file
end

groups.duplicates.each do |k,group|
  death_queue = options[:remove_policy].choose_to_die(group)
  survivor = [death_queue.first]
  death_queue = death_queue.slice(1..-1)
  if options[:dry]
    puts (survivor + death_queue.map { |s| "   " + s }).join("\n")
  else
    death_queue.each { |file| File.delete file }
  end
end




