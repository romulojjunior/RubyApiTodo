class UserAccountInteractor
  attr_reader :encrypter_service
  attr_reader :user_repository

  class AttrDuplicationError < StandardError; end

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
      raise AttrDuplicationError.new "Field duplicated"
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
