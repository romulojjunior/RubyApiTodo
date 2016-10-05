require "rails_helper"

describe API::V1::AuthAPI do
  let(:user_account_interactor) { instance_spy UserAccountInteractor }

  before do
    Grape::Endpoint::before_each do |endpoint|
      allow(endpoint).to receive(:user_account).and_return(user_account_interactor)
    end
  end

  endpoint "POST /api/v1/auth/signup" do
    let(:user) { build :user }
    let(:params) { { email: user.email, password: user.password } }
    let(:make_request) { post path, params: params }

    subject { make_request }

    describe "response body" do
      before do
        allow(user_account_interactor).to receive(:create).and_return(user)
        make_request
      end
      subject { response.body }

      it do
        expect(subject).to include_json(api_key: user.api_key)
      end
    end
  end
end
