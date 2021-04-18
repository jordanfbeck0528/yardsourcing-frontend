require 'rails_helper'

describe 'As an authenticated user when I visit the host yard show page' do
  before :each do
    user = User.create!(id:1, uid: '123545', username: 'Dominic Padula', email:'thisemail@gmail.com', password: SecureRandom.hex(15) )
    omniauth_response = stub_omniauth_happy('123545', 'Dominic Padula', 'thisemail@gmail.com')
    @user_1 = User.from_omniauth(omniauth_response)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user_1)
  end

  it "I see links to renter/host dashboard and logout" do
    VCR.use_cassette('yard_details') do
      visit yard_path(2)
      within '.nav-bar' do
        expect(page).to have_button("Host Dashboard")
        expect(page).to have_button("Renter Dashboard")
        expect(page).to have_button("Logout")
      end
    end
  end

  it "I see the yard information" do
    VCR.use_cassette('yard_details') do
      visit yard_path(2)
      within '.yard-details' do
        expect(page).to have_content('Address: 123 4th St Denver, CO 80202')
        expect(page).to have_content('Description: This yard is equiped with a firepit, a pool, and a pool house to accommodate all your party needs.')
        expect(page).to have_content('Availability: Available on weekends in May')
        expect(page).to have_content('Price per Hour: $20.00')
        expect(page).to have_content('Payment Information: Venmo')
        expect(page).to have_content('Purposes:')
        expect(page).to have_content('Pet Rental')
        expect(page).to have_content('Party Rental')
      end
    end
  end
  it "I see the yard images if they exist" do
    VCR.use_cassette('yard_details') do
      visit yard_path(2)
      within '.yard-images' do
        expect(page).to have_xpath("/html/body/section[3]/img")
      end
    end
  end
end
