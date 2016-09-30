class EncrypterService
  def self.encrypt_password(password)
    Digest::SHA1.hexdigest password
  end

  def self.valid_password?(password, hash)
    hash == self.encrypt_password(password)
  end
end
