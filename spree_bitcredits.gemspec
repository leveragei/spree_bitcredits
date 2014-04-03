Gem::Specification.new do |s|

  s.platform = Gem::Platform::RUBY
  s.name = 'spree_bitcredits'
  s.version = '1.3.4'
  s.summary = 'Add a bitcoins support to your spree store'
  s.description = 'The '
  s.required_ruby_version = '>= 1.8.7'


  s.author = 'Inessa Barkan'
  s.email = 'InessaBarkan@gmail.com'

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.has_rdoc = false

  s.add_dependency 'spree_core', '~> 1.3.2'

  s.add_development_dependency 'capybara', '~> 1.1.2'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'factory_girl', '~> 2.6.4'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'rspec-rails', '~> 2.9'
  s.add_development_dependency 'sass-rails'
  s.add_development_dependency 'sqlite3'
end