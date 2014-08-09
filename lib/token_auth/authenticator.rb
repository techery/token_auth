module TokenAuth
  module Authenticator
    extend ActiveSupport::Concern

    included do
      private :authenticate_entity_by_token!
    end

    def authenticate_entity_by_token!(authenticable_class)
      @current_entity ||= authenticate_with_http_token do |token, options|
        authenticable_class.find_by_authentication_token(token)
      end

      raise Unauthorized unless @current_entity.present?
    end


    module ClassMethods
      def acts_as_token_authenticator_for(authenticable_class, options = {})
        authenticable_class_underscored = authenticable_class.name.parameterize.singularize.underscore

        before_filter :"authenticate_#{authenticable_class_underscored}_by_token!"

        class_eval <<-AUTHENTICATOR, __FILE__, __LINE__ + 1
          def authenticate_#{authenticable_class_underscored}_by_token!
            authenticate_entity_by_token!(#{authenticable_class})
          end
        AUTHENTICATOR
      end
    end
  end
end

ActionController::Base.send :include, TokenAuth::Authenticator
