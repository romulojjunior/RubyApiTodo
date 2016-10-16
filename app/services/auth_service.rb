class AuthService
  attr_reader :user_repository

  class ApiKeyNotFound < StandardError; end

  def initialize(user_repository: UserRepository.new)
    @user_repository = user_repository
  end

  def current_user(api_key)
    user = user_repository.find_by_api_key(api_key)
    raise ApiKeyNotFound.new "Api key not found." if user.nil?
    user
  end
end
