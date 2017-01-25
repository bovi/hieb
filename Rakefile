require 'rubygems/package_task'
require 'rake/testtask'

spec = Gem::Specification.new do |s|
  s.name         = 'hieb'
  s.version      = '0.0.2'
  s.date         = '2017-01-25'
  s.summary      = "Simple deployment tool"
  s.description  = "Simple deployment tool using SSH and supporting command execution and file upload"
  s.authors      = ["Daniel Bovensiepen"]
  s.email        = 'daniel@bovensiepen.net'
  s.files        = Dir.glob("{bin}/**/*") + %w(LICENSE README.md)
  s.executables  = ['hieb']
  s.add_runtime_dependency 'net-ssh', '~> 4.0', '>= 4.0.1'
  s.homepage     = 'https://github.com/bovi/hieb'
  s.license      = 'MIT'
end

Gem::PackageTask.new(spec) do |pkg|
  pkg.need_zip = true
  pkg.need_tar = true
end

task :clean => [:clobber_package]
