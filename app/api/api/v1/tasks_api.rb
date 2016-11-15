module API
  module V1
    class TasksAPI < Grape::API
      helpers API::Helpers::Auth

      helpers do
        def task_interactor
          @task_interactor ||= TaskInteractor.new
        end

        def task_repository
          @task_repository ||= TaskRepository.new
        end
      end

      resource :tasks do
        desc "Return a task"
        params do
          requires :id, type: Integer, allow_blank: false
        end
        get "/:id" do
          begin
            validate_api_key

            task_id = params[:id]
            task = task_interactor.find_by_user_and_task_id(current_user, task_id)
            present task, with: API::V1::Entities::Task
          rescue TaskInteractor::TaskNotFound
            error!({ error: 'Task not found' }, 404)
          end
        end
      end
    end
  end
end
