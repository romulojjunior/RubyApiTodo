module API
  class V1::Base < Grape::API
    version "v1"
    mount API::V1::AuthAPI
    mount API::V1::CardsAPI
    mount API::V1::TasksAPI
  end
end
