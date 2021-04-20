require 'rails_helper'
RSpec.describe "New Booking Page" do
  describe 'As an authenticated user when I visit the new booking page' do
    before :each do
      user = User.create!(id:1, uid: '123545', username: 'Dominic Padula', email:'thisemail@gmail.com')
      omniauth_response = stub_omniauth_happy('123545', 'Dominic Padula', 'thisemail@gmail.com')
      @user_1 = User.from_omniauth(omniauth_response)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user_1)
    end

    it "I see a form with the yard name, event name, date, start time, duration, and description" do
      VCR.use_cassette('host_yard_show_page_ultimate_party') do
        VCR.use_cassette('booking/new_booking') do
          visit new_yard_booking_path(2)
          expect(page).to have_content("Yard: Ultimate Party Yard")
          expect(page).to have_field('booking_name')
          expect(page).to have_field('date')
          expect(page).to have_field('time')
          expect(page).to have_field('duration')
          expect(page).to have_field('description')
        end
      end
    end
  end
end
