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
        expect(page).to have_xpath("/html/body/section[3]/img")
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
end
