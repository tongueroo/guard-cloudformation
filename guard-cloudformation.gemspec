# -*- encoding: utf-8 -*-
require File.expand_path('../lib/guard/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Tung Nguyen"]
  gem.email         = ["tongueroo@gmail.com"]
  gem.description   = %q{Guard::Cloudformation automatically validates cloud formation templates.}
  gem.summary       = %q{Guard::Cloudformation automatically validates cloud formation templates.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "guard-cloudformation"
  gem.require_paths = ["lib"]
  gem.version       = Guard::CLOUDFORMATION_VERSION

  gem.add_dependency "colorize"
  gem.add_dependency "guard"
  gem.add_dependency "popen4"
end
