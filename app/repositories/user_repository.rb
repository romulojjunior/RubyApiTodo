class UserRepository
  def create(email, encrypted_password, api_key)
    User.create(email: email, password: encrypted_password, api_key: api_key)
  end

  def find_by_email(email)
    User.find_by_email(email)
  end

  def find_by_api_key(api_key)
    User.find_by_api_key(api_key)
  end
end
