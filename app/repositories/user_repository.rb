class UserRepository
  def create(email, encrypted_password, api_key)
    User.create(email: email, password: encrypted_password, api_key: api_key)
  end
end
