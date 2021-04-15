require 'rails_helper'

describe 'As an authenticated user when I visit the host dashboard' do
  before :each do
    @current_user = User.create!(username: 'username', password: 'password1', email: 'email@email.com')
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
      expect(page).to have_content("Welcome #{@current_user.username}")
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

  xit "I see a section for all of my yards I have created" do
    stub_request(:get, "localhost:3001/api/v1/yards").
    to_return(status: 200, body: {"data":[{"id":"1","type":"yard","attributes":{"host_id":1,"name":"name","street_address":"address","city":"city","state":"state","zipcode":12345,"price":"20.25","description":"words and things","availability":"never","payment":"rubies only","photo_url_1":null,"photo_url_2":null,"photo_url_3":null}},{"id":"2","type":"yard","attributes":{"host_id":1,"name":"name2","street_address":"address2","city":"city2","state":"state2","zipcode":12342,"price":"20.00","description":"more words and things","availability":"never ever","payment":"rubies or gems  only","photo_url_1":null,"photo_url_2":null,"photo_url_3":null}}]}, headers: {})

    visit host_dashboard_index_path

    within '.my-yards' do

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
