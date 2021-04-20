require 'rails_helper'

describe 'As an authenticated user when I visit the renters dashboard' do
  before :each do
    user = User.create!(id:1, uid: '123545', username: 'Dominic Padula', email:'thisemail@gmail.com')
    omniauth_response = stub_omniauth_happy('123545', 'Dominic Padula', 'thisemail@gmail.com')
    @user_1 = User.from_omniauth(omniauth_response)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user_1)
  end

  describe 'Happy Path' do
    it 'I see an upcoming booking section' do
      visit renter_dashboard_index_path

      within('.upcoming-bookings') do
        expect(page).to have_content("Upcoming Booking's:")
      end
    end
    it 'I see a pending bookings section' do
      visit renter_dashboard_index_path

      within('.pending-bookings') do
        expect(page).to have_content("Pending Booking's:")
      end
    end
    it 'I see a find your next yard button' do
      visit renter_dashboard_index_path

      expect(page).to have_button('Find your next yard')
    end

    it 'I click on the find your next yard button, and it takes you to the search index path' do
      visit renter_dashboard_index_path

      click_on 'Find your next yard'
      expect(current_path).to eq(search_index_path)
    end

    it 'I see a list of approved upcoming boookings' do
      VCR.use_cassette('approved_bookings') do
        visit renter_dashboard_index_path

        within('.upcoming-bookings') do
          expect(page).to have_link('Pet Birthday Party')
        end

        click_link 'Pet Birthday Party'
        expect(current_path).to eq(yard_path(2))
      end
    end

    it 'I see a list of approved upcoming boookings' do
      VCR.use_cassette('approved_bookings') do
        visit renter_dashboard_index_path

        within('.upcoming-bookings') do
          expect(page).to have_content("Address: 123 4th St Denver, CO 80202")
          expect(page).to have_content("Date: 04/25/2021")
          expect(page).to have_content("Duration: 3 hours")
          expect(page).to have_content("Total Cost: $60.00")
          expect(page).to have_content("Image:")
          expect(page).to have_xpath("//img[@src = 'https://i.pinimg.com/originals/33/68/61/33686194d9ec6fff887d4a77b33fab26.jpg']")
        end
      end
    end
  end
end
