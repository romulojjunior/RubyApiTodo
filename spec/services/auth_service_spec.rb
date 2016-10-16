require "rails_helper"

describe AuthService do
  let(:user) { build :user }
  let(:user_repository) { instance_spy UserRepository }
  let(:auth_service) { described_class.new(user_repository: user_repository) }

  describe "#current_user" do
    before do
      allow(user_repository).to receive(:find_by_api_key).and_return(user)
    end

    subject { auth_service.current_user(user.api_key) }

    it do
      is_expected.to eq user
    end

    context "when api key not found" do
      before do
        allow(user_repository).to receive(:find_by_api_key).and_return(nil)
      end

      subject { auth_service.current_user(user.api_key) }

      it do
        expect { subject }.to raise_error AuthService::ApiKeyNotFound
      end
    end
  end
end
