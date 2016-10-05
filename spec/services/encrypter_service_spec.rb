require "rails_helper"

describe EncrypterService do
  let(:encrypter_service) { described_class }
  let(:user) { build :user }
  let(:password) { user.password }
  let(:password_encrypted)  { Digest::SHA1.hexdigest password }

  describe ".encrypt_password" do
    subject { encrypter_service.encrypt_password(password) }

    it do
      subject
      is_expected.to eq password_encrypted
    end
  end

  describe ".valid_password?" do
    subject { encrypter_service.valid_password?(password, password_encrypted) }

    it do
      subject
      is_expected.to be true
    end

    context "when password is invalid" do
      let(:invalid_password) { "xxxxxx" }
      subject { encrypter_service.valid_password?(invalid_password, password_encrypted) }

      it do
        subject
        is_expected.to be false
      end
    end
  end
end
