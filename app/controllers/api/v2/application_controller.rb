module Api::V2

  class ApplicationController < ActionController::API
    include ActionController::HttpAuthentication::Token::ControllerMethods
    include ActionController::HttpAuthentication::Basic::ControllerMethods
  
    swagger_controller :application, 'Application Management'
  
    swagger_api :token do |_api|
      summary 'Authenticate with email and password to get token'
      param :header, 'Authorization', :string, :required, "Email and password in the format of: Basic {Base64.encode64('email:password')}"
    end
  
    before_action :authenticate, except: [:token]
  
    # A method to handle initial authentication
    def token
      authenticate_username_password || render_unauthorized
    end
  
    protected
  
    def authenticate_username_password
      authenticate_or_request_with_http_basic do |email, password|
        user = User.authenticate(email, password)
        render json: user if user
      end
    end
  
    def authenticate
      authenticate_token || render_unauthorized
    end
  
    def authenticate_token
      authenticate_with_http_token do |token, _options|
        @current_user = User.find_by(api_key: token)
      end
    end
  
    def render_unauthorized(realm = 'Application')
      headers['WWW-Authenticate'] = %(Token realm="#{realm.delete('"')}")
      render json: { error: 'Bad Credentials' }, status: :unauthorized
    end
  
    class << self
        def inherited(subclass)
          super
          subclass.class_eval do
            setup_basic_api_documentation
          end
        end
  
      private
  
        def setup_basic_api_documentation
          %i[index show create update delete].each do |api_action|
            swagger_api api_action do
              param :header, 'Authorization', :string, :required, 'Authentication token in the format of: Token token="2eed18b92a86d0258af43b3376e9b823"'
            end
          end
        end
      end
    end  
end