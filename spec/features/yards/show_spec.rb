require 'rails_helper'

RSpec.describe "As an authenticated user when I visit the Yard Show Page" do
  before :each do
    user = User.create!(id:1, uid: '123545', username: 'Dominic Padula', email:'thisemail@gmail.com')
    omniauth_response = stub_omniauth_happy('123545', 'Dominic Padula', 'thisemail@gmail.com')
    @user_1 = User.from_omniauth(omniauth_response)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user_1)
  end

  describe "Happy path" do
    it "I see links to renter/host dashboard and logout" do
      VCR.use_cassette('yards/show_yard_4') do
        visit yard_path(4)
        within '.nav-bar' do
          expect(page).to have_button("Host Dashboard")
          expect(page).to have_button("Renter Dashboard")
          expect(page).to have_button("Logout")
        end
      end
    end

    it "displays a button to 'Rent' the yard if the current user is the renter" do
      VCR.use_cassette('yards/show_yard_4') do
        visit yard_path(4)

        expect(page).to have_button('Rent Yard')
      end
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
  describe "Sad path for engine failure" do
    xit 'Displays an error, and re-directs when engine errors.' do
      # error = 'Data cannot be accessed at this time'
      # stub_request(:get, "#{ENV['ys_engine_url']}/api/v1/yards/1")
      # .to_return(status: [500, error], headers: {})

      # with above stub it errors out in facade after refactor
      # below stub actually simulates a timeout
      # but we need to recover from Faraday error inside of EngineService

      stub_request(:get, "#{ENV['ys_engine_url']}/api/v1/yards/1")
      .to_timeout
      response = "Faraday::ConnectionFailed: execution expired"

      visit yard_path(1)

      expect(page).to have_content(error)
      expect(current_path).to eq(host_dashboard_index_path)
    end
  end
end
