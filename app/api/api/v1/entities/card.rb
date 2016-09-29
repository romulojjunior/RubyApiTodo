module API
  module V1
    class Entities::Card < Grape::Entity
      expose :name
      expose :status
      expose :tasks, with: API::V1::Entities::Task
    end
  end
end
