require 'rails_helper'

describe 'As an authenticated user when I visit the host yard show page' do
  before :each do
    user = User.create!(id:1, uid: '123545', username: 'Dominic Padula', email:'thisemail@gmail.com', password: SecureRandom.hex(15) )
    omniauth_response = stub_omniauth_happy('123545', 'Dominic Padula', 'thisemail@gmail.com')
    @user_1 = User.from_omniauth(omniauth_response)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user_1)
  end

  it "I see links to renter/host dashboard and logout" do
    visit yard_path(2)
    within '.nav-bar' do
      expect(page).to have_button("Host Dashboard")
      expect(page).to have_button("Renter Dashboard")
      expect(page).to have_button("Logout")
    end
  end

  it "I see the yard information" do
    visit yard_path(1)
    within '.header' do
      expect(page).to have_content('Yard Name')
    end
  end
end
