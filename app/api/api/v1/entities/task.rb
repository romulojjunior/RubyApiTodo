module API
  module V1
    class Entities::Task < Grape::Entity
      expose :id
      expose :name
      expose :status
      expose :description
    end
  end
end
