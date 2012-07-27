# -*- encoding: utf-8 -*-
require File.expand_path('../lib/tastetest/version', __FILE__)

Gem::Specification.new do |gem|
    gem.name          = "tastetest"
    gem.authors       = ["Jonathan Hartman"]
    gem.email         = ["jon.hartman@rackspace.com"]
    gem.summary       = "Integrates assorted Chef testing tools"
    gem.description   = "Integrates assorted Chef testing tools"
    gem.homepage      = "https://github.com/RSEmail/tastetest"

    gem.files         = `git ls-files`.split($\)
    gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
    gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
    gem.require_paths = ["lib"]
    gem.version       = TasteTest::VERSION

    gem.add_dependency("foodcritic")
    gem.add_dependency("chefspec")
    gem.add_dependency("minitest-chef-handler")

    gem.add_development_dependency("rspec")
end

# vim:et:fdm=marker:sts=4:sw=4:ts=4:
