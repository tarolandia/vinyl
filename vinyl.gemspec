$:.push File.expand_path("../lib", __FILE__)
require "vinyl/version"

Gem::Specification.new do |gem|
  gem.name          = "vinyl"
  gem.authors       = ["Federico Saravia Barrantes", "Lautaro Orazi"]
  gem.email         = ["vinyl.dev@gmail.com"]
  gem.description   = %q{Custom access level for resources}
  gem.summary       = %q{Custom access level for resources}
  gem.homepage      = "http://tarolandia.github.com/vinyl/"
  gem.version       = Vinyl::VERSION

  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.require_paths = ["lib"]

  gem.add_development_dependency 'rspec', '~> 2.7'
end
