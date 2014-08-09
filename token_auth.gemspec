$:.push File.expand_path("../lib", __FILE__)

require 'token_auth/version'

Gem::Specification.new do |s|
  s.name        = 'token_auth'
  s.version     = TokenAuth::VERSION
  s.authors     = ['Anna Balina', 'Michael Kurtikov', 'Sergey Stupachenko']
  s.email       = ['hello@techery.io']
  s.homepage    = 'https://github.com/techery/token_auth'
  s.summary     = 'Token-based authentication'
  s.description = 'Token-based authentication gem for Rails'
  s.license     = 'MIT'

  s.files  =  Dir['lib/**/*', 'MIT-LICENSE', 'README.md']
end
