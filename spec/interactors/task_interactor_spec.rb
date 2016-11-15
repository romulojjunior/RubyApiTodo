require "rails_helper"

describe TaskInteractor do
  let(:user) { build :user }
  let(:task) { build(:task, id: 1) }
  let(:task_repository) { instance_spy TaskRepository }
  let(:task_interactor) { described_class.new(task_repository: task_repository) }

  describe "#find_by_user_and_task_id" do
    before do
      allow(task_repository).to receive(:find_by_user_and_task_id)
      .with(user, task.id)
      .and_return(task)
    end

    subject { task_interactor.find_by_user_and_task_id(user, task.id) }

    it { is_expected.to eq task }

    context "when user is invalid" do
      let(:invalid_user) { nil }

      before do
        allow(task_repository).to receive(:find_by_user_and_task_id)
          .with(invalid_user, task.id)
          .and_raise(TaskInteractor::InvalidUserError)
      end

      subject { task_interactor.find_by_user_and_task_id(invalid_user, task.id) }

      it "raise a TaskInteractor::InvalidUserError" do
        expect { subject }.to raise_error(TaskInteractor::InvalidUserError)
      end
    end

    context "when a task is invalid" do
      let(:invalid_task_id) { nil }

      before do
        allow(task_repository).to receive(:find_by_user_and_task_id)
          .with(user, invalid_task_id)
          .and_raise(TaskInteractor::TaskNotFound)
      end

      subject { task_interactor.find_by_user_and_task_id(user, invalid_task_id) }

      it "raise a TaskInteractor::TaskNotFound" do
        expect { subject }.to raise_error(TaskInteractor::TaskNotFound)
      end
    end
  end

  describe "#remove_from_user_and_task_id" do
    before do
      allow(task_repository).to receive(:remove_from_user_and_task_id)
      .with(user, task.id)
      .and_return(task)
    end

    subject { task_interactor.remove_from_user_and_task_id(user, task.id) }

    it { is_expected.to eq task }

    context "when user is invalid" do
      let(:invalid_user) { nil }

      before do
        allow(task_repository).to receive(:remove_from_user_and_task_id)
          .with(invalid_user, task.id)
          .and_raise(TaskInteractor::InvalidUserError)
      end

      subject { task_interactor.remove_from_user_and_task_id(invalid_user, task.id) }

      it "raise a TaskInteractor::InvalidUserError" do
        expect { subject }.to raise_error(TaskInteractor::InvalidUserError)
      end
    end

    context "when a task is invalid" do
      let(:invalid_task_id) { nil }

      before do
        allow(task_repository).to receive(:find_by_user_and_task_id)
          .with(user, invalid_task_id)
          .and_raise(TaskInteractor::TaskNotFound)
      end

      subject { task_interactor.find_by_user_and_task_id(user, invalid_task_id) }

      it "raise a TaskInteractor::TaskNotFound" do
        expect { subject }.to raise_error(TaskInteractor::TaskNotFound)
      end
    end
  end
end
