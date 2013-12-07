# Copyright 2013 Daneel S. Yaitskov

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#     http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'digest/md5'

module FindDuplicates
  class PolicyLeaveLongest
    def choose_to_die(files)
      files.sort { |a,b| b.size - a.size }
    end
  end

  class DummyBar
    def increment
    end
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

  def find_duplicates(options, paths)
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
  end
end
