require 'rails_helper'

RSpec.describe "As an authenticated user when I visit the Yard Show Page" do
  before :each do
    user = User.create!(id:1, uid: '123545', username: 'Dominic Padula', email:'thisemail@gmail.com', password: SecureRandom.hex(15) )
    omniauth_response = stub_omniauth_happy('123545', 'Dominic Padula', 'thisemail@gmail.com')
    @user_1 = User.from_omniauth(omniauth_response)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user_1)
  end

  it "I see links to renter/host dashboard and logout" do
    VCR.use_cassette('host_yard_show_page_ultimate_party') do
      visit yard_path(2)
      within '.nav-bar' do
        expect(page).to have_button("Host Dashboard")
        expect(page).to have_button("Renter Dashboard")
        expect(page).to have_button("Logout")
      end
    end
  end

  it "I see the yard information" do
    VCR.use_cassette('host_yard_show_page_ultimate_party') do
      visit yard_path(2)
      within '.yard-details' do
        expect(page).to have_content('Address: 123 4th St Denver, CO 80202')
        expect(page).to have_content('Description: This yard is equiped with a firepit, a pool, and a pool house to accommodate all your party needs.')
        expect(page).to have_content('Availability: Available on weekends in May')
        expect(page).to have_content('Price per Hour: $20.00')
        expect(page).to have_content('Payment Information: Venmo')
        expect(page).to have_content('Purposes:')
        expect(page).to have_content('Pet Rental')
        expect(page).to have_content('Party Rental')
      end
    end
  end

  it "I see the yard images if they exist" do
    VCR.use_cassette('host_yard_show_page_ultimate_party') do
      visit yard_path(2)
      within '.yard-images' do
        expect(page).to have_xpath("/html/body/section[3]/img")
      end
    end
  end

  skip "displays a button to 'Rent' the yard if the current user is the renter" do
    VCR.use_cassette('renter_yard_show_page_ultimate_party') do
      visit renter_dashboard_index_path
      save_and_open_page
      click_on "Large Yard for any Hobby"

      expect(current_path).to eq('/yards/2')
      expect(page).to have_button('Rent Yard')
    end
  end

  it "displays a button to 'Edit' the yard if the current user is the host" do
    VCR.use_cassette('host_yard_show_page_hobby') do
      visit host_dashboard_index_path
      click_on "Large Yard for any Hobby"

      expect(current_path).to eq('/yards/3')
      expect(page).to have_button('Edit Yard')
    end
  end

  describe "As a renter & sad path" do
    it "displays a button to 'Rent' the yard if the current user is the renter" do
      response = File.open("spec/fixtures/renter_yard_show_page.json")
      stub_request(:get, "#{ENV['ys_engine_url']}/api/v1/yards/10652").
         with(
           headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent'=>'Faraday v1.3.0'
           }).
           to_return(status: 200, body: response, headers: {})

      visit yard_path(10652)

      expect(page).to have_button('Rent Yard')
    end
  end
  describe "no yard matches id" do
    it "displays a button to 'Rent' the yard if the current user is the renter" do
      VCR.use_cassette('yard_show_page_edge_case') do
        visit yard_path(106500002)

        expect(page).to have_no_button('Rent Yard')
        expect(page).to have_no_button('Edit Yard')
        expect(page).to have_no_content('Availability')
      end
    end
  end
end