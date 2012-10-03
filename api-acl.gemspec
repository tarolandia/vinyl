$:.push File.expand_path("../lib", __FILE__)
require "api-acl/version"

Gem::Specification.new do |gem|
  gem.name          = "api-acl"
  gem.authors       = ["Federico Saravia Barrantes", "Lautaro Orazi"]
  gem.email         = ["orazile@gmail.com"]
  gem.description   = %q{Custom ACL for APIs}
  gem.summary       = %q{Custom ACL for APIs}
  gem.homepage      = ""
  gem.version       = ACL::VERSION

  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.require_paths = ["lib"]

  gem.add_development_dependency 'rspec', '~> 2.7'
  gem.add_dependecy 'singleton'
end
