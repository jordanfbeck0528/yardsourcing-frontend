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
      VCR.use_cassette('bookings/new_booking_yard_2') do
        visit new_yard_booking_path(2)
        
        expect(page).to have_content("Yard: Ultimate Party Yard")
        expect(page).to have_field('booking_name')
        expect(page).to have_field('date')
        expect(page).to have_field('time')
        expect(page).to have_field('duration')
        expect(page).to have_field('description')
      end
    end

    describe 'happy path' do
      it "when I fill out the form with valid information I can create a booking" do
        VCR.use_cassette('bookings/new_booking_yard_2_submit') do
          visit new_yard_booking_path(2)
          fill_in :booking_name, with: "A new booking!!"
          fill_in :date, with: Date.new(2021, 05,05)
          fill_in :time, with: Time.new(2021,05,05,12)
          fill_in :duration, with: 2
          fill_in :description, with: 'description'

          click_button 'Create Booking'
          expect(current_path).to eq(renter_dashboard_index_path)
          #expect(page).to have_content("A new booking!!")
        end
      end
    end

    describe 'sad path' do
      it "when I do not enter a name I cannot create a booking" do
        VCR.use_cassette('bookings/new_booking_yard_2_no_name') do
          visit new_yard_booking_path(2)
          fill_in :date, with: Date.new(2021, 05,05)
          fill_in :time, with: Time.new(2021,05,05,12)
          fill_in :duration, with: 2
          fill_in :description, with: 'description'
          click_button 'Create Booking'
          expect(page).to have_content("Validation failed: Booking name can't be blank")
        end
      end
      it "when I do not enter a date I cannot create a booking" do
        VCR.use_cassette('bookings/new_booking_yard_2_no_date') do
          visit new_yard_booking_path(2)
          fill_in :booking_name, with: "A new booking!!"
          fill_in :time, with: Time.new(2021,05,05,12)
          fill_in :duration, with: 2
          fill_in :description, with: 'description'
          click_button 'Create Booking'
          expect(page).to have_content("Validation failed: Date can't be blank")
        end
      end

      it 'when I do not enter a time I cannot create a booking' do
        VCR.use_cassette('bookings/new_booking_yard_2_no_time') do
          visit new_yard_booking_path(2)
          fill_in :booking_name, with: "A new booking!!"
          fill_in :date, with: Date.new(2021, 05,05)
          fill_in :duration, with: 2
          fill_in :description, with: 'description'
          click_button 'Create Booking'
          expect(page).to have_content("Validation failed: Time can't be blank")
        end
      end

      it 'when I do not enter a duration I cannot create a booking' do
        VCR.use_cassette('bookings/new_booking_yard_2_no_duration') do
          visit new_yard_booking_path(2)
          fill_in :booking_name, with: "A new booking!!"
          fill_in :date, with: Date.new(2021, 05,05)
          fill_in :time, with: Time.new(2021,05,05,12)
          fill_in :description, with: 'description'
          click_button 'Create Booking'
          expect(page).to have_content("Validation failed: Duration can't be blank")
        end
      end

      it 'when I do not enter a description I cannot create a booking' do
        VCR.use_cassette('bookings/new_booking_yard_2_no_description') do
          visit new_yard_booking_path(2)
          fill_in :booking_name, with: "A new booking!!"
          fill_in :date, with: Date.new(2021, 05,05)
          fill_in :time, with: Time.new(2021,05,05,12)
          fill_in :duration, with: 2
          click_button 'Create Booking'
          expect(page).to have_content("Validation failed: Description can't be blank")
        end
      end

      it 'when I enter a date from the past I cannot create a booking' do
        VCR.use_cassette('bookings/new_booking_yard_2_date_in_past') do
          visit new_yard_booking_path(2)
          fill_in :booking_name, with: "A new booking!!"
          fill_in :date, with: Date.new(2021, 03,05)
          fill_in :time, with: Time.new(2021,05,05,12)
          fill_in :duration, with: 2
          fill_in :description, with: 'description'
          click_button 'Create Booking'
          expect(page).to have_content("Validation failed: Date Booking Date can't be in the past")
        end
      end
    end
  end
end
