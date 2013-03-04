# Encoding: UTF-8
require File.expand_path('../lib/refinery/menus/version.rb', __FILE__)

version = Refinery::Menus::Version.to_s

Gem::Specification.new do |s|
  s.platform          = Gem::Platform::RUBY
  s.name              = %q{refinerycms-menus}
  s.version           = version
  s.summary           = %q{Pages Menus extension for Refinery CMS}
  s.description       = %q{Add custom menus to pages}
  s.date              = Date.today.strftime("%Y-%m-%d")
  s.email             = %q{johan@pylonweb.dk}
  s.homepage          = %q{http://github.com/pylonweb/refinerycms-menus}
  s.authors           = ['Johan Frølich']
  s.license           = %q{MIT}
  s.require_paths     = %w(lib)

  s.files             = Dir["{app,config,db,lib}/**/*"] + ["readme.md"]
  s.test_files        = Dir["spec/**/*"] + ["Guardfile"]

  # Runtime dependencies
  s.add_dependency    'refinerycms-core',    '~> 2.0.9'
  s.add_dependency    'awesome_nested_set', '~> 2.1.0'
  s.add_dependency    'initforthe-routes', '~> 0.0.2'

  # Development dependencies (usually used for testing)
  s.add_development_dependency 'refinerycms-testing', '~> 2.0.9'
end
