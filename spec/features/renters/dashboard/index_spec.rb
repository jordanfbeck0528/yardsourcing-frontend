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
    #need to unskip after initial search info is complete
    #issue number 13
    xit 'I click on the find your next yard button, and it takes you to the search index path' do
      visit renter_dashboard_index_path

      click_on 'Find your next yard'
      expect(current_path).to eq(search_index_path)
    end
  end
end
