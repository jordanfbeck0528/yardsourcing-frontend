require 'rails_helper'

describe 'As an authenticated user when I visit the renters dashboard' do
  before :each do
    user = User.create!(id:1, uid: '123545', username: 'Dominic Padula', email:'thisemail@gmail.com')
    omniauth_response = stub_omniauth_happy('123545', 'Dominic Padula', 'thisemail@gmail.com')
    @user_1 = User.from_omniauth(omniauth_response)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user_1)
  end
  it "No bookings available" do
    user = User.create!(id:200, uid: '899981', username: 'Minnie Mouse', email:'minnie@mouse.com' )
     omniauth_response_3 = stub_omniauth_happy('899981', 'Minnie Mouse', 'minnie@mouse.com')
     user_3 = User.from_omniauth(omniauth_response_3)
     allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user_3)

     VCR.use_cassette('bookings/no_bookings') do
       visit renter_dashboard_index_path

       within('.upcoming-bookings') do
         expect(page).to have_content("Upcoming Bookings:")
       end
     end
  end
  describe 'Happy Path' do
    it 'I see an upcoming booking section' do
      VCR.use_cassette('renters/dash/landing_page') do
        visit renter_dashboard_index_path

        within('.upcoming-bookings') do
          expect(page).to have_content("Upcoming Bookings:")
        end
      end
    end

    it 'I see a pending bookings section' do
      VCR.use_cassette('renters/dash/landing_page') do
        visit renter_dashboard_index_path

        within('.pending-bookings') do
          expect(page).to have_content("Pending Bookings:")
        end
      end
    end

    it 'I click on the find your next yard button, and it takes you to the search index path' do
      VCR.use_cassette('renters/dash/search_yards') do
        visit renter_dashboard_index_path

        click_on 'Find your next yard'
        expect(current_path).to eq(search_index_path)
      end
    end

    it 'I see a list of approved upcoming boookings' do
      VCR.use_cassette('renters/dash/approved_booking_1') do
        visit renter_dashboard_index_path

        within('.upcoming-bookings') do
          expect(page).to have_link('Pet Birthday Party')
        end

        click_link 'Pet Birthday Party'
        expect(current_path).to eq(booking_path(1))
      end
    end

    it 'I see a list of attributes for approved upcoming boookings' do
      VCR.use_cassette('renters/dash/landing_page') do
        visit renter_dashboard_index_path

        within('.upcoming-bookings') do
          expect(page).to have_content("Address: 2001 Blake St Denver, CO 80205")
          expect(page).to have_content("Date: 04/25/2021")
          expect(page).to have_content("Duration: 3 hours")
          expect(page).to have_content("Total Cost: $60.00")
          expect(page).to have_xpath("//img[@src = 'https://i.pinimg.com/originals/33/68/61/33686194d9ec6fff887d4a77b33fab26.jpg']")
        end
      end
    end

    it 'I see a list of pending boookings' do
      VCR.use_cassette('renters/dash/pending_booking_5') do
        visit renter_dashboard_index_path

        within('.pending-bookings') do
          expect(page).to have_link('Spotlight Tag')
        end

        click_link 'Spotlight Tag'
        expect(current_path).to eq(booking_path(5))
      end
    end

    it 'I see a list of attributes for pending boookings' do
      VCR.use_cassette('renters/dash/pending_booking') do
        visit renter_dashboard_index_path

        within('.pending-bookings') do
          expect(page).to have_content("Address: 3181 E 23rd Ave Denver, CO 80205")
          expect(page).to have_content("Date: 05/05/2021")
          expect(page).to have_content("Duration: 2 hours")
          expect(page).to have_content("Total Cost: $31.00")
          expect(page).to have_content("No image")
        end
      end
    end
    it 'I can click on the yard link' do
      VCR.use_cassette('renters/dash/pending_booking_4') do
        visit renter_dashboard_index_path
        within('.pending-bookings') do
          expect(page).to have_link('Multipurpose Yard')
        end

        click_link 'Multipurpose Yard'
        expect(current_path).to eq(yard_path(4))
      end
    end
    describe "I see a button for cancel booking if the booking is more than 48 hours away" do
      it "If not pending, I see the status of Approved or Rejected" do
        VCR.use_cassette('bookings/renter_bookings_cancel') do
          booking_params = {:renter_id=>"1",
                          :renter_email=>"renter@renter.com",
                          :yard_id=>"2",
                          :booking_name=>"DLT THIS BOOKING",
                          :date=>"2021-05-05",
                          :time=>"2021-05-05 12:00:00 -0500",
                          :duration=>"2",
                          :description=>"description"}

          es = EngineService.create_booking(booking_params)
          visit renter_dashboard_index_path
          within "#booking-#{es[:data][:id]}" do
            expect(page).to have_button("Cancel Booking")
            click_button "Cancel Booking"
          end
          expect(page).to_not have_content("DLT THIS BOOKING")
        end
      end
    end
  end
end
