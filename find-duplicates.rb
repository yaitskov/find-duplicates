#!/usr/bin/ruby


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
require 'yaml'

options = { :remove => false }
begin
  OptionParser.new do |opts|
    opts.banner = 'Usage: find-duplicates.rb [ options ] <path-to-dir>'
    opts.on('-d', '--remove-duplicates',
            'find duplicated files and remove them') do |v|
      options[:remove] = true 
    end
  end.parse!

  if ARGV.empty?
    raise "there isn't any path given"  
  end

  ARGV.each do |path| 
    raise "path '#{ path }' isn't a directory" if !File.directory?(path)
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
    File.open(path, 'rb') do |file_h|
      file_h.each(8192) do |block|
        md5.update block
      end
    end
    digest = md5.digest
    if @hashes.key?(digest)
      @hashes[digest] << path
    else
      @hashes[digest] = [ path ]
    end
  end  
  def print_info
    dups = @hashes.find_all { |k,v| v.size > 1 }
    if dups.empty?
      puts "no duplicates"
    else
      puts dups.to_yaml
    end
  end
end

groups = Groups.new
ARGV.each do |path|
  Dir.glob(path + '/**/*') do |file|
    next if File.directory?(file)
    groups.add file
  end
end

if options[:remove]
  raise 'no supported yet'
else # print only
  groups.print_info
end


