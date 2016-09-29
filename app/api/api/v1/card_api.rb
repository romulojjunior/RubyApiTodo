module API
  class V1::CardAPI < Grape::API
    resource :card do
      get "/" do
        present Card.first, with: API::V1::Entities::Card
      end
    end
  end
end
