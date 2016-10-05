module API
  module V1
    class Entities::ApiKey < Grape::Entity
      expose :api_key
    end
  end
end
