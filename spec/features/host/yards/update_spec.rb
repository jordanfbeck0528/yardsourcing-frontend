require 'rails_helper'

require 'rails_helper'

describe 'As an authenticated user when I visit the edit yard page' do
  before :each do
    user = User.create!(id:1, uid: '123545', username: 'Dominic Padula', email:'thisemail@gmail.com', password: SecureRandom.hex(15) )
    omniauth_response = stub_omniauth_happy('123545', 'Dominic Padula', 'thisemail@gmail.com')
    @user_1 = User.from_omniauth(omniauth_response)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user_1)
  end

  describe "happy path" do
    it "I see a form prepopulated with the yards stored information" do
      visit host_yards_path
      save_and_open_page

    end
    it "When the form is submitted it updates the yard" do

    end
  end
  describe "sad path" do
    it "flashes an error message when a required section is left blank" do

    end
  end
end
