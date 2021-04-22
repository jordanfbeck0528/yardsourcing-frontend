require 'rails_helper'

RSpec.describe "As an authenticated user when I visit the Yard Show Page" do
  before :each do
    user = User.create!(id:1, uid: '123545', username: 'Dominic Padula', email:'thisemail@gmail.com')
    omniauth_response = stub_omniauth_happy('123545', 'Dominic Padula', 'thisemail@gmail.com')
    @user_1 = User.from_omniauth(omniauth_response)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user_1)
  end

  it "I see links to renter/host dashboard and logout" do
    VCR.use_cassette('host/yards/show_yard_2') do
      visit host_yard_path(2)
      within '.nav-bar' do
        expect(page).to have_button("Host Dashboard")
        expect(page).to have_button("Renter Dashboard")
        expect(page).to have_button("Logout")
      end
    end
  end

  it "I see the yard information" do
    VCR.use_cassette('host/yards/show_yard_2') do
      visit host_yard_path(2)

      expect(page).to have_css(".yard-details")
    end
  end

  it "I see the yard images if they exist" do
    VCR.use_cassette('host/yards/show_yard_2') do
      visit host_yard_path(2)
      within '.yard-images' do
        expect(page).to have_xpath("/html/body/div/section[2]/img")
      end
    end
  end

  it "displays a button to 'Edit' the yard if the current user is the host" do
    VCR.use_cassette('host/yards/show_yard_2') do
      visit host_yard_path(2)

      expect(page).to have_button('Edit Yard')
    end
  end

  describe "no yard matches id" do
    it "displays a button to 'Rent' the yard if the current user is the renter" do
      VCR.use_cassette('host/yards/show_yard_bad_id') do
        visit yard_path(106500002)

        expect(page).to have_no_button('Rent Yard')
        expect(page).to have_no_button('Edit Yard')
        expect(page).to have_no_content('Availability')
      end
    end
  end

  describe "I can delete yard" do
    it "I see the Delete yard button where I can delete a yard " do
      VCR.use_cassette('host/yards/delete_yard') do
        yard_params = { :name=>"DELETE THIS YARD",
                        :email=>"email@email.com",
                        :host_id=>"123545",
                        :description=>"description",
                        :availability=>"availability",
                        :payment=>"payment",
                        :price=>"25.2",
                        :street_address=>"street_address",
                        :city=>"city",
                        :state=>"state",
                        :zipcode=>"zipcode",
                        :photo_url_1=>"https://photo.com/path",
                        :photo_url_2=>"",
                        :photo_url_3=>"",
                        :purposes=>["1", "3"]}

        es = EngineService.create_yard(yard_params)
        visit host_yard_path(es[:data][:id])
        expect(page).to have_button("Delete Yard")
        click_button "Delete Yard"

        expect(current_path).to eq host_dashboard_index_path
        expect(page).to_not have_content("DELETE THIS YARD")
      end
    end
  end

  describe "I can't delete yard with active bookings" do
    it "I see the Delete yard button where I can delete a yard " do
      VCR.use_cassette('host/yards/delete_yard_active_bookings') do
        yard_params = { :name=>"DELETE THIS YARD",
                        :email=>"email@email.com",
                        :host_id=>"123545",
                        :description=>"description",
                        :availability=>"availability",
                        :payment=>"payment",
                        :price=>"25.2",
                        :street_address=>"street_address",
                        :city=>"city",
                        :state=>"state",
                        :zipcode=>"zipcode",
                        :photo_url_1=>"https://photo.com/path",
                        :photo_url_2=>"",
                        :photo_url_3=>"",
                        :purposes=>["1", "3"]}

        yard = EngineService.create_yard(yard_params)

        booking_params = {:renter_id=>"1",
                        :renter_email=>"renter@renter.com",
                        :yard_id=>"#{yard[:data][:id]}",
                        :booking_name=>"A new booking!!",
                        :status=>"approved",
                        :date=>"2021-05-05",
                        :time=>"2021-05-05 12:00:00 -0500",
                        :duration=>"2",
                        :description=>"description"}

        booking = EngineService.create_booking(booking_params)

        visit host_yard_path(yard[:data][:id])
        expect(page).to have_button("Delete Yard")
        click_button "Delete Yard"

        expect(current_path).to eq host_yard_path(yard[:data][:id])
        expect(page).to have_content("Can't delete a yard with active bookings")
      end
    end
  end
end
