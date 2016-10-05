module API
  module V1
    class CardAPI < Grape::API
      resource :cards do
        get "/" do
          present Card.first, with: API::V1::Entities::Card
        end
      end
    end
  end
end
