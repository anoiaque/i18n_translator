# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "i18n_translator/version"

Gem::Specification.new do |s|
  s.name        = "i18n_translator"
  s.version     = I18nTranslator::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Philippe Cantin"]
  s.email       = ["anoiaque@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Automatically create translated locales files of a rails project}
  s.description = %q{Automatically create translated locales files of a rails project from a source Locale. Example: > rake i18n:translate['en','fr;es']. See more on github}

  s.rubyforge_project = "i18n_translator"

  s.files = Dir['lib/**/*.rb', 'lib/**/*.rake']
  s.require_path = "lib"
  s.test_files  = Dir['test/**/*.rb']
  s.has_rdoc = true
  s.extra_rdoc_files = ["README.rdoc"]
end
