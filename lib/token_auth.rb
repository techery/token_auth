module TokenAuthentication

  module ActsAsTokenAuthenticatable
    extend ActiveSupport::Concern

    included do
      private :generate_token
    end

    def ensure_authentication_token
      self.authentication_token = generate_token if authentication_token.blank?
    end

    def generate_token
      begin
        # token = Devise.friendly_token
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

  module ActsAsTokenAuthenticator
    extend ActiveSupport::Concern

    included do
      private :authenticate_by_token!
      before_filter :authenticate_by_token!
    end

    def self.set_entity entity
      @@entity = entity
    end

    def authenticate_by_token!
      authenticate || render_unauthorized
    end

    def authenticate
      @current_user = authenticate_with_http_token do |token, options|
        @@entity.find_by_authentication_token(token)
      end
    end

    def render_unauthorized
      render status: :unauthorized, json: { error: 'Unauthorized' }
    end

    module ClassMethods
      def acts_as_token_authenticator_for(entity, options = {})
        TokenAuthentication::ActsAsTokenAuthenticator.set_entity entity
      end
    end
  end

end

ActiveRecord::Base.send :include, TokenAuthentication::ActsAsTokenAuthenticatable
ActionController::Base.send :include, TokenAuthentication::ActsAsTokenAuthenticator
