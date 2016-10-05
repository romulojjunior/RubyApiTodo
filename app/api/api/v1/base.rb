module API
  class V1::Base < Grape::API
    version "v1"
    mount API::V1::CardAPI
    mount API::V1::AuthAPI
  end
end
