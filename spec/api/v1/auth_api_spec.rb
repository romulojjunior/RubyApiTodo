require "rails_helper"

describe API::V1::AuthAPI do
  let(:user_account_interactor) { instance_spy UserAccountInteractor }

  before do
    Grape::Endpoint::before_each do |endpoint|
      allow(endpoint).to receive(:user_account)
        .and_return(user_account_interactor)
    end
  end

  endpoint "POST /api/v1/auth/signup" do
    let(:user) { build :user }
    let(:params) { { email: user.email, password: user.password } }
    let(:make_request) { post path, params: params }

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

  endpoint "POST /api/v1/auth/signin" do
    let(:user) { build :user }

    describe "response body" do
      let(:params) { { email: user.email, password: user.password } }
      let(:make_request) { post path, params: params }

      before do
        allow(user_account_interactor).to receive(:authenticate)
          .and_return(user.api_key)
          make_request
      end

      subject { response.body }

      it do
        expect(subject).to include_json(api_key: user.api_key)
      end
    end

    describe "invalid params" do
      context "when user email not found" do
        let(:params) { { email: "invalid@email.com", password: user.password } }
        let(:make_request) { post path, params: params }

        before do
          allow(user_account_interactor).to receive(:authenticate)
            .and_raise(UserAccountInteractor::EmailNotFoundError)
        end

        subject { make_request }

        it do
          is_expected.to eq 404
        end
      end

      context "when user password is worng" do
        let(:params) { { email: user.email, password: "fake#{user.password}" } }
        let(:make_request) { post path, params: params }

        before do
          allow(user_account_interactor).to receive(:authenticate)
            .and_raise(UserAccountInteractor::InvalidPassword)
        end

        subject { make_request }

        it do
          is_expected.to eq 401
        end
      end
    end
  end
end
