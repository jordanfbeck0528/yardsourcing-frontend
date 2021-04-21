require 'rails_helper'

RSpec.describe "As an authenticated user when I visit the Booking Show Page" do
  before :each do
    user = User.create!(id:1, uid: '123545', username: 'Dominic Padula', email:'thisemail@gmail.com')
    omniauth_response = stub_omniauth_happy('123545', 'Dominic Padula', 'thisemail@gmail.com')
    @user_1 = User.from_omniauth(omniauth_response)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user_1)
  end

  xit "I see links to renter/host dashboard and logout" do
    VCR.use_cassette('booking/show_booking') do
      visit booking_path(1)
      within '.nav-bar' do
        expect(page).to have_button("Host Dashboard")
        expect(page).to have_button("Renter Dashboard")
        expect(page).to have_button("Logout")
      end
    end
  end

  xit "I see the booking information" do
    VCR.use_cassette('booking/show_booking') do
      visit booking_path(2)

      expect(page).to have_css(".booking-details")
    end
  end
end
