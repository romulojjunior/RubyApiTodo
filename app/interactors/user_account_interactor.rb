class UserAccountInteractor
  attr_reader :encrypter_service
  attr_reader :user_repository

  class AttrDuplicationError < StandardError; end
  class EmailNotFoundError < StandardError; end
  class InvalidPassword <StandardError; end

  def initialize(encrypter_service: EncrypterService, user_repository: UserRepository.new)
    @encrypter_service = encrypter_service
    @user_repository = user_repository
  end

  def create(email, password)
    encrypted_password = encrypter_service.encrypt_password(password)
    api_key = create_api_key()

    begin
    user_repository.create(email, encrypted_password, api_key)
    rescue ActiveRecord::RecordNotUnique
      raise AttrDuplicationError.new "Field duplicated."
    end
  end

  def authenticate(email, password)
    user = user_repository.find_by_email(email)
    raise EmailNotFoundError.new "Email not found." if user.nil?

    if encrypter_service.valid_password?(password, user.password)
      return user.api_key
    else
      raise InvalidPassword.new "Invalid password."
    end
  end

  private

  def create_api_key
    tokenCreated = false
    token = nil
    while !tokenCreated
      token = SecureRandom.urlsafe_base64(nil, false)
      tokenCreated = User.find_by_api_key(token).nil?
    end
    token
  end
end
