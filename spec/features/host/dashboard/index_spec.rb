require 'rails_helper'

describe 'As an authenticated user when I visit the host dashboard' do
  before :each do
    user = User.create!(id:1, uid: '123545', username: 'Dominic Padula', email:'thisemail@gmail.com' )
    omniauth_response = stub_omniauth_happy('123545', 'Dominic Padula', 'thisemail@gmail.com')
    @user_1 = User.from_omniauth(omniauth_response)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user_1)
  end

  it "I see links to renter/host dashboard and logout" do
    VCR.use_cassette('host/dashboard/host_yards') do
      visit host_dashboard_index_path

      within '.nav-bar' do
        expect(page).to have_button("Host Dashboard")
        expect(page).to have_button("Renter Dashboard")
        expect(page).to have_button("Logout")
      end
    end
  end

  it "I see a welcome message with my username" do
    VCR.use_cassette('host/dashboard/host_yards') do
      visit host_dashboard_index_path

      within '.nav-bar' do
        expect(page).to have_content("Welcome #{@user_1.username}")
      end
    end
  end

  it "I see a button to create a yard" do
    VCR.use_cassette('host/dashboard/host_create_yard') do
      visit host_dashboard_index_path

      within '.header' do
        expect(page).to have_button('Create Yard')
        click_on 'Create Yard'
      end

      expect(current_path).to eq(new_host_yard_path)
    end
  end

  it "I see a section for all of my yards I have created" do
    VCR.use_cassette('host/dashboard/host_yards') do
      visit host_dashboard_index_path

      expect(page).to have_css(".my-yards")
    end
  end

  it "I see a section for my yards with a note about no yards when I have not added any" do
    user = User.create!(id:100, uid: '899980', username: 'Mickey Mouse', email:'mousey@mouse.com' )
    omniauth_response_2 = stub_omniauth_happy('899980', 'Mickey Mouse', 'mousey@mouse.com')
    user_2 = User.from_omniauth(omniauth_response_2)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user_2)

    VCR.use_cassette('no_host_yards') do
      visit host_dashboard_index_path

      expect(page).to have_content("Add some yards to rent! Turn your green into green!")
      expect(page).to have_button("Create Yard")
    end
  end

  describe "I see a section for Upcoming Bookings" do
    it "I see a link for dates and times for each booking" do
      VCR.use_cassette('host/dashboard/host_yards') do
        visit host_dashboard_index_path
        within '.my-upcoming-bookings' do
          expect(page).to have_link("Pet Birthday Party")
          expect(page).to have_link("3 Year Old Birthday Party")
          expect(page).to have_link("Barbeque with Friends")
          expect(page).to_not have_link("Spotlight Tag")
        end
      end
    end

    describe "If pending, I see “Approve” and “Deny” buttons for each booking" do
      it "If I click Approve, the status changes to approve and I no longer see buttons" do
        VCR.use_cassette('host/dashboard/approve_booking') do
          booking_params = {:renter_id=>"1",
                          :renter_email=>"renter@renter.com",
                          :yard_id=>"2",
                          :booking_name=>"A new booking!!",
                          :date=>"2021-05-05",
                          :time=>"2021-05-05 12:00:00 -0500",
                          :duration=>"2",
                          :description=>"description"}

          es = EngineService.create_booking(booking_params)
          visit host_dashboard_index_path
          within "#booking-#{es[:data][:id]}" do
            expect(page).to have_button("Approve")
            expect(page).to have_button("Reject")
            click_on "Approve"
          end
          within "#booking-#{es[:data][:id]}" do
            expect(page).to have_content("Approved")
            expect(page).to_not have_button("Approve")
            expect(page).to_not have_button("Reject")
          end
        end
      end
      it "If I click Rejected, the status changes to approve and I no longer see buttons" do
        VCR.use_cassette('host/dashboard/reject_booking') do
          booking_params = {:renter_id=>"1",
                          :renter_email=>"renter@renter.com",
                          :yard_id=>"2",
                          :booking_name=>"Rejected booking!",
                          :date=>"2021-05-05",
                          :time=>"2021-05-05 12:00:00 -0500",
                          :duration=>"2",
                          :description=>"description"}

          es = EngineService.create_booking(booking_params)
          visit host_dashboard_index_path
          within "#booking-#{es[:data][:id]}" do
            expect(page).to have_button("Approve")
            expect(page).to have_button("Reject")
            click_on "Reject"
          end
          expect(page).to_not have_content("Rejected booking!")
        end
      end

      it "If not pending, I see the status of Approved or Rejected" do
        VCR.use_cassette('host/dashboard/host_yards') do
          visit host_dashboard_index_path

          within '#booking-1' do
            expect(page).to_not have_button("Approve")
            expect(page).to_not have_button("Reject")
          end
        end
      end
    end
    describe "I see a button for cancel booking if the booking is more than 48 hours away" do
      it "If not within 48 hours, I see the Cancel Booking button" do
        VCR.use_cassette('bookings/host_bookings_cancel') do
          booking_params = {:renter_id=>"1",
                          :renter_email=>"renter@renter.com",
                          :yard_id=>"2",
                          :status=>"approved",
                          :booking_name=>"DELETE THIS BOOKING!",
                          :date=>"2021-05-05",
                          :time=>"2021-05-05 12:00:00 -0500",
                          :duration=>"2",
                          :description=>"description"}

          es = EngineService.create_booking(booking_params)
          visit host_dashboard_index_path
          within "#booking-#{es[:data][:id]}" do
            expect(page).to have_button("Cancel Booking")
            click_button "Cancel Booking"
          end
          expect(page).to_not have_content("DELETE THIS BOOKING!")
        end
      end
    end
  end
end
