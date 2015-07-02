Gem::Specification.new do |s|
  s.name        = 'activemeta-rspec'
  s.version      = '0.0.1'
  s.platform     = Gem::Platform::RUBY
  s.licenses     = ['MIT']
  s.summary      = 'Rspec helpers for ActiveMeta'
  s.homepage     = 'https://github.com/savemysmartphone/activemeta-rspec'
  s.description  = 'Alice will think of a better description than me :)'
  s.authors      = ["Alice Clavel", "Arnaud 'red' Rouyer"]

  s.files        = `git ls-files`.split("\n")
  s.require_path = 'lib'
  s.required_ruby_version = '>= 2.0.0'
end
