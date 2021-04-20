require 'rails_helper'

describe 'As an authenticated user when I visit the host dashboard' do
  before :each do
    user = User.create!(id:1, uid: '123545', username: 'Dominic Padula', email:'thisemail@gmail.com' )
    omniauth_response = stub_omniauth_happy('123545', 'Dominic Padula', 'thisemail@gmail.com')
    @user_1 = User.from_omniauth(omniauth_response)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user_1)
  end

  it "I see links to renter/host dashboard and logout" do
    VCR.use_cassette('host_yards') do
      visit host_dashboard_index_path

      within '.nav-bar' do
        expect(page).to have_button("Host Dashboard")
        expect(page).to have_button("Renter Dashboard")
        expect(page).to have_button("Logout")
      end
    end
  end

  it "I see a welcome message with my username" do
    VCR.use_cassette('host_yards') do
      visit host_dashboard_index_path

      within '.nav-bar' do
        expect(page).to have_content("Welcome Dominic Padula")
      end
    end
  end

  it "I see a button to create a yard" do
    VCR.use_cassette('all_purposes_dash') do
      visit host_dashboard_index_path

      within '.header' do
        expect(page).to have_link('Create Yard')
        click_on 'Create Yard'
      end

      expect(current_path).to eq(new_host_yard_path)
    end
  end

  it "Each yard is a link to that yard's show page"

  it "I see a section for all of my yards I have created" do
    VCR.use_cassette('host_yards') do
      visit host_dashboard_index_path

      expect(page).to have_css(".yard_info")
    end
  end

  it "I see a section for my yards with a note about no yards when I have not added any" do
    response = File.open("spec/fixtures/host_yards0.json")
    stub_request(:get, "#{ENV['ys_engine_url']}/api/v1/hosts/1/yards").
       with(
         headers: {
        'Accept'=>'*/*',
        'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'User-Agent'=>'Faraday v1.3.0'
         }).
         to_return(status: 200, body: response, headers: {})

    visit host_dashboard_index_path

    expect(page).to have_content("Add some yards to rent! Turn your green into green!")
    expect(page).to have_button("Create Yard")
  end

  describe "I see a section for Upcoming Bookings" do
    it "I see a link for dates and times for each booking"

    it "If pending, I see “Approve” and “Deny” buttons for each booking"

    it "If not pending, I see the status of Approved or Rejected"
  end
end
