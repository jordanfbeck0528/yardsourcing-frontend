class OmniauthMacros
  def mock_auth_hash

    OmniAuth.config.mock_auth[:google] = OmniAuth::AuthHash.new({
      :provider => 'google',
      :uid => '123545',
      :info => {
      :username => 'Dominic Padula',
      :email => 'thisemail@gmail.com',
      :password => SecureRandom.hex(15)
      },
      :credentials => {
      :token => 'mock_token',
      :secret: => 'mock_secret'
      } })
  end
end
