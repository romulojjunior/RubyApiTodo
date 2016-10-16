module API
  class Base < Grape::API

    # Errors
    rescue_from AuthService::ApiKeyNotFound do |e|
      error!("outer")
      error!({ error: 'Invalid api key.' }, 401, { 'Content-Type' => 'application/json' })
    end

    # Configs
    format :json
    mount API::V1::Base
  end
end
