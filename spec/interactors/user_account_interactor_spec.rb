require 'rails_helper'

describe UserAccountInteractor do
  let(:user) { build :user }
  let(:encrypted_password) { Digest::SHA1.hexdigest user.password }
  let(:user_repository) { instance_spy UserRepository }
  let(:encrypter_service) { class_spy EncrypterService }
  let(:interactor) do
    described_class.new(
      encrypter_service: encrypter_service,
      user_repository: user_repository
    )
  end

  before do
    allow(encrypter_service).to receive(:encrypt_password).and_return(encrypted_password)
    allow(user_repository).to receive(:create).and_return(user)
    allow(user_repository).to receive(:find_by_email).and_return(user)
  end

  describe "#create" do
    subject { interactor.create(user.email, user.password) }

    it do
      is_expected.to eq user
    end

    context "when user already signed" do
      before do
        allow(encrypter_service).to receive(:encrypt_password).and_return(encrypted_password)
        allow(user_repository).to receive(:create).and_raise(ActiveRecord::RecordNotUnique)
      end

      it "raise a error"  do
        expect { subject }.to raise_error UserAccountInteractor::AttrDuplicationError
      end
    end
  end

  describe "#authenticate" do
    subject { interactor.authenticate(user.email, user.password) }

    it do
      is_expected.to eq user.api_key
    end

    context "when user email not found" do
      let(:invalid_email) { "invalid_#{user.email}"}
      before do
        allow(user_repository).to receive(:find_by_email).and_return(nil)
      end

      subject { interactor.authenticate(invalid_email, user.password) }

      it "raise a error" do
        expect { subject }.to raise_error(UserAccountInteractor::EmailNotFoundError)
      end
    end

    context "when user password is wrong" do
      let(:wrong_password) { "fake_#{user.password}" }
      before do
        allow(encrypter_service).to receive(:valid_password?).and_return(false)
      end

      subject { interactor.authenticate(user.email, wrong_password) }

      it "raise a error" do
        expect { subject }.to raise_error(UserAccountInteractor::InvalidPassword)
      end
    end
  end
end
