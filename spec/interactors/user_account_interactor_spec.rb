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

  describe "#create" do
    before do
      allow(encrypter_service).to receive(:encrypt_password).and_return(encrypted_password)
      allow(user_repository).to receive(:create).and_return(user)
    end

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
end
