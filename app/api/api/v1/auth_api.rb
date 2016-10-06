module API
  module V1
    class AuthAPI < Grape::API

      helpers do
        def user_account
          @user_account ||= UserAccountInteractor.new
        end
      end

      resource :auth do
        desc "Create a user account."
        params do
          requires :email, type: String, allow_blank: false
          requires :password, type: String, allow_blank: false
        end
        post :signup do
          email = params['email']
          password = params['password']

          begin
            user = user_account.create(email, password)
            result = { api_key: user.api_key }
            present result, with: API::V1::Entities::ApiKey
          rescue UserAccountInteractor::AttrDuplicationError
            status 400
          end
        end

        desc "Signin a user"
        params do
          requires :email, type: String, allow_blank: false
          requires :password, type: String, allow_blank: false
        end
        post :signin do
          email = params['email']
          password = params['password']

          begin
            api_key = user_account.authenticate(email, password)
            result = { api_key: api_key }
            present result, with: API::V1::Entities::ApiKey
          rescue UserAccountInteractor::EmailNotFoundError
            status 404
          rescue UserAccountInteractor::InvalidPassword
            status 401
          end
        end
      end
    end
  end
end
