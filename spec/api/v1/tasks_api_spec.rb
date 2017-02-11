require "rails_helper"

describe API::V1::TasksAPI do
  let(:task) { build :task, id: 1 }
  let(:user) { build :user }
  let(:task_interactor) { instance_spy TaskInteractor }
  let(:task_repository) { instance_spy TaskRepository }

  before do
    Grape::Endpoint::before_each do |endpoint|
      allow(endpoint).to receive(:task_interactor).and_return(task_interactor)
      allow(endpoint).to receive(:task_repository).and_return(task_repository)
      allow(endpoint).to receive(:validate_api_key).and_return(user)
      allow(endpoint).to receive(:current_user).and_return(user)
    end
  end

  after { Grape::Endpoint.before_each(nil) }

  endpoint "GET /api/v1/tasks/:id" do
    let(:make_request) { get "/api/v1/tasks/#{task.id}" }

    describe "response body" do
      before do
        allow(task_interactor).to receive(:find_by_user_and_task_id)
          .with(user, task.id).and_return(task)
      end

      subject { response.body }

      it do
        make_request
        attrs = {name: task.name, status: task.status, description: task.description}
        expect(subject).to include_json(attrs)
      end

      context "when a task not found" do
        before do
          allow(task_interactor).to receive(:find_by_user_and_task_id)
            .and_raise(TaskInteractor::TaskNotFound)
        end

        subject { response.body }

        it do
          make_request
          expect(subject).to include_json(error:"Task not found")
        end
      end
    end
  end


  endpoint "PUT /api/v1/tasks/:id" do
    let(:params) do
      {
        id: task.id,
        name: "My new task name",
        status: "doing",
        description: "A simple description"
      }
    end
    let(:task_updated) { build :task, params }
    let(:make_request) { put "/api/v1/tasks/#{task.id}", params: params }

    describe "response body" do
      before do
        allow(task_interactor).to receive(:update_from_user_and_attributes)
          .with(user, params).and_return(task_updated)
      end

      subject { response.body }

      it do
        make_request
        attrs = {name: params[:name], status: params[:status], description: params[:description]}
        expect(subject).to include_json(attrs)
      end

      context "when task not found" do
        before do
          allow(task_interactor).to receive(:update_from_user_and_attributes)
            .and_raise(TaskInteractor::TaskNotFound)
        end

        subject { response.body }

        it do
          make_request
          expect(subject).to include_json(error:"Task not found")
        end
      end
    end
  end

  endpoint "DELETE /api/v1/tasks/:id" do
    let(:make_request) { delete "/api/v1/tasks/#{task.id}" }

    describe "response body" do
      before do
        allow(task_interactor).to receive(:remove_from_user_and_task_id)
          .with(user, task.id).and_return(task)
      end

      subject { response.body }

      it do
        make_request
        attrs = {name: task.name, status: task.status, description: task.description}
        expect(subject).to include_json(attrs)
      end

      context "when task not found" do
        before do
          allow(task_interactor).to receive(:remove_from_user_and_task_id)
            .and_raise(TaskInteractor::TaskNotFound)
        end

        subject { response.body }

        it do
          make_request
          expect(subject).to include_json(error:"Task not found")
        end
      end
    end
  end
end
