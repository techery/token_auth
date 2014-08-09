module TokenAuth
  module Authenticator
    extend ActiveSupport::Concern

    included do
      private :authenticate_by_token!
    end

    def self.set_entity entity
      @@entity = entity
    end

    def authenticate_by_token!
      authenticate || (raise Unauthorized)
    end

    def authenticate
      @current_user = authenticate_with_http_token do |token, options|
        @@entity.find_by_authentication_token(token)
      end
    end

    module ClassMethods
      def acts_as_token_authenticator_for(entity, options = {})
        before_filter :authenticate_by_token!
        TokenAuth::Authenticator.set_entity entity
      end
    end
  end
end

ActionController::Base.send :include, TokenAuth::Authenticator
