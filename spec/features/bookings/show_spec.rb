require 'rails_helper'

RSpec.describe "As an authenticated user when I visit the Booking Show Page" do
  before :each do
    user = User.create!(id:1, uid: '123545', username: 'Dominic Padula', email:'thisemail@gmail.com')
    omniauth_response = stub_omniauth_happy('123545', 'Dominic Padula', 'thisemail@gmail.com')
    @user_1 = User.from_omniauth(omniauth_response)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user_1)
    VCR.use_cassette('bookings/booking_id_1') do
      @booking = BookingFacade.get_booking(1)
    end
  end

  it "I see links to renter/host dashboard and logout" do
    VCR.use_cassette('bookings/show_booking') do
      visit booking_path(1)
      within '.nav-bar' do
        expect(page).to have_button("Host Dashboard")
        expect(page).to have_button("Renter Dashboard")
        expect(page).to have_button("Logout")
      end
    end
  end

  it "I see the booking information" do
    VCR.use_cassette('bookings/show_booking_info') do
      visit booking_path(1)

      within '.booking-details' do
        expect(page).to have_content("Yard: #{@booking.yard_name}")
        expect(page).to have_content("Address: #{@booking.address}")
        expect(page).to have_content("Status: #{@booking.status.titleize}")
        expect(page).to have_content("Date: #{@booking.date.strftime('%m/%d/%Y')}")
        expect(page).to have_content("Time: #{@booking.time.strftime('%I:%M%p')}")
        expect(page).to have_content("Duration: #{@booking.duration}")
        expect(page).to have_content("Total Cost: $60.00")
        expect(page).to have_content("Description: #{@booking.description}")

        expect(page).to have_link("#{@booking.yard_name}")
        click_link("#{@booking.yard_name}")
        expect(current_path).to eq(yard_path("#{@booking.yard_id}"))
      end
    end
  end

  xit "I see the booking information" do
    VCR.use_cassette('bookings/show_booking-info') do
      visit booking_path(1)
      within '.booking-details' do
        expect(page).to have_button("Delete Booking")
        click_button("Delete Booking")
      end
    end
  end
end
