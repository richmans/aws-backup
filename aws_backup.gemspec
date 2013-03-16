# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'aws-backup/version'

Gem::Specification.new do |gem|
  gem.name          = "aws-backup"
  gem.version       = AwsBackup::VERSION
  gem.authors       = ["Richard Bronkhorst"]
  gem.email         = ["richard.bronkhorst@gmail.com"]
  gem.description   = "A gem to provision manage and use amazon S3 accounts for backups"
  gem.summary       = "S3 Backup manager"
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency 'rake'
  gem.add_runtime_dependency 'thor'
  gem.add_runtime_dependency 'rainbow'
  gem.add_runtime_dependency 'aws-sdk'
end
