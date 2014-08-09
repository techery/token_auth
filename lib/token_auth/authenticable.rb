module TokenAuth
  module Authenticatable
    extend ActiveSupport::Concern

    included do
      private :generate_token
    end

    def ensure_authentication_token
      self.authentication_token = generate_token if authentication_token.blank?
    end

    def generate_token
      begin
        token = SecureRandom.hex
      end while self.class.exists?(authentication_token: token)

      token
    end

    module ClassMethods
      def acts_as_token_authenticatable(options = {})
        before_save :ensure_authentication_token
      end
    end
  end
end

ActiveRecord::Base.send :include, TokenAuth::Authenticatable
