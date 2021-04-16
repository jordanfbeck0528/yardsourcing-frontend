require 'rails_helper'

describe 'As an authenticated user when I visit the host dashboard' do
  before :each do
    stub_omniauth_happy
    visit root_path
    click_button 'Login through Google'
    @user = User.find_by(uid: 123545)
  end
  it "I see links to renter/host dashboard and logout" do
    visit host_dashboard_index_path

    within '.nav-bar' do
      expect(page).to have_button("Host Dashboard")
      expect(page).to have_button("Renter Dashboard")
      expect(page).to have_button("Logout")
    end
  end

  it "I see a welcome message with my username" do
    visit host_dashboard_index_path

    within '.nav-bar' do
      expect(page).to have_content("Welcome Dominic Padula")
    end
  end

  it "I see a button to create a yard" do
    stub_request(:get, "https://localhost:3001/api/v1/purposes").
        with(
          headers: {
         'Accept'=>'*/*',
         'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
         'User-Agent'=>'Faraday v1.3.0'
          }).
        to_return(status: 200, body: '{"data":[{"id":"1","type":"purpose","attributes":{"name":"name1"}},{"id":"2","type":"purpose","attributes":{"name":"name2"}}]}', headers: {})

    visit host_dashboard_index_path

    within '.header' do
      expect(page).to have_button('Create Yard')
      click_button 'Create Yard'
    end

    expect(current_path).to eq(new_host_yard_path)
  end

  it "Each yard is a link to that yard's show page" do

  end

  it "I see a section for all of my yards I have created" do
    visit host_dashboard_index_path

    stub_request(:get, "https://localhost:3001/api/v1/hosts/123545/yards").
        with(
          headers: {
         'Accept'=>'*/*',
         'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
         'User-Agent'=>'Faraday v1.3.0'
          }).
        to_return(status: 200, body: "", headers: {})
        
    within '.my-yards' do
      expect(page).to have_content("My Yard(s)")
        within "#yard-1" do
          expect(page).to have_content("Mike's Awesome Yard")
        end
        within "#yard-2" do
          expect(page).to have_content("Bohem Garden")
        end
        within "#yard-3" do
          expect(page).to have_content("Rooftop Party")
        end
    end
  end

  describe "I see a section for Upcoming Bookings" do
    it "I see a link for dates and times for each booking" do

    end

    it "If pending, I see “Approve” and “Deny” buttons for each booking" do

    end

    it "If not pending, I see the status of Approved or Rejected" do

    end
  end
end
