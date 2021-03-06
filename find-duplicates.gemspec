Gem::Specification.new do |s|
  s.name    = 'find-duplicates'
  s.version = '0.0.2'
  s.date    = '2013-12-07'
  s.summary = 'Find duplicated files'
  s.description = 'Find and remove duplicated files'
  s.authors = [ 'Daneel S. Yaitskov' ]
  s.email   = 'rtfm.rtfm.rtfm@gmail.com'
  s.files = [ 'bin/find-duplicates',              
              'lib/find-duplicates.rb',
              'find-duplicates.gemspec'
            ]
  s.require_paths = [ 'bin', 'lib' ]
  s.executable = 'find-duplicates'
  s.license = 'Apache 2'
  s.homepage = 'https://github.com/yaitskov/find-duplicates'
  s.add_dependency "ruby-progressbar"
  s.add_dependency "bundler"  
end
