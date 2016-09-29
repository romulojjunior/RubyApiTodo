module API
  module V1
    class Entities::Task < Grape::Entity
      expose :name
      expose :status
      expose :description
    end
  end
end
