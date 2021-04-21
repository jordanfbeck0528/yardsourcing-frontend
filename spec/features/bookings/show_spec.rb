require 'rails_helper'

RSpec.describe "As an authenticated user when I visit the Booking Show Page" do
  before :each do
    user = User.create!(id:1, uid: '123545', username: 'Dominic Padula', email:'thisemail@gmail.com')
    omniauth_response = stub_omniauth_happy('123545', 'Dominic Padula', 'thisemail@gmail.com')
    @user_1 = User.from_omniauth(omniauth_response)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user_1)
  end

  it "I see links to renter/host dashboard and logout" do
    VCR.use_cassette('booking/show_booking') do
      visit booking_path(1)
      within '.nav-bar' do
        expect(page).to have_button("Host Dashboard")
        expect(page).to have_button("Renter Dashboard")
        expect(page).to have_button("Logout")
      end
    end
  end

  it "I see the booking information" do
    VCR.use_cassette('booking/show_booking-with-yard') do
      visit booking_path(1)
      within '.booking-details' do
        expect(page).to have_content("Yard: Ultimate Party Yard")
        expect(page).to have_content("Address: 2001 Blake St Denver, CO 80205")
        expect(page).to have_content("Status: Approved")
        expect(page).to have_content("Date: 04/25/2021")
        expect(page).to have_content("Time: 02:00PM")
        expect(page).to have_content("Duration: 3 hours")
        expect(page).to have_content("Total Cost: $60.00")
        expect(page).to have_content("Description: Throwing a bday party for my pet.")

        expect(page).to have_link("Ultimate Party Yard")
        click_link("Ultimate Party Yard")
        expect(current_path).to eq(yard_path(2))
      end
    end
  end

  xit "I see the booking information" do
    VCR.use_cassette('booking/show_booking') do
      visit booking_path(1)
      within '.booking-details' do
        expect(page).to have_button("Delete Booking")
        click_button("Delete Booking")
      end
    end
  end
end
