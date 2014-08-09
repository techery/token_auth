module TokenAuth
  class Unauthorized < StandardError; end

  require 'token_auth/authenticable'
  require 'token_auth/authenticator'

  require 'token_auth/version'
end
