require 'rails_helper'

describe 'As an authenticated user when I visit the new yard page' do
  before :each do
    stub_omniauth_happy
    visit root_path
    click_button 'Login through Google'
    user = User.find_by(uid: 123545)

    stub_request(:get, "https://localhost:3001/api/v1/purposes").
        with(
          headers: {
         'Accept'=>'*/*',
         'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
         'User-Agent'=>'Faraday v1.3.0'
          }).
        to_return(status: 200, body: '{"data":[{"id":"1","type":"purpose","attributes":{"name":"name1"}},{"id":"2","type":"purpose","attributes":{"name":"name2"}},{"id":"3","type":"purpose","attributes":{"name":"name3"}}]}', headers: {})

        stub_request(:post, "https://localhost:3001/api/v1/yards").
        with(
          body: {"{\"yard\":\"{\\\"host_id\\\""=>">#{user.id}, \\\"name\\\"=>\\\"name\\\", \\\"description\\\"=>\\\"description\\\", \\\"availability\\\"=>\\\"availability\\\", \\\"payment\\\"=>\\\"payment\\\", \\\"price\\\"=>\\\"25.2\\\", \\\"street_address\\\"=>\\\"street_address\\\", \\\"city\\\"=>\\\"city\\\", \\\"state\\\"=>\\\"state\\\", \\\"zipcode\\\"=>\\\"zipcode\\\", \\\"photo_url_1\\\"=>\\\"https://photo.com/path\\\", \\\"photo_url_2\\\"=>\\\"\\\", \\\"photo_url_3\\\"=>\\\"\\\", \\\"purposes\\\"=>[\\\"1\\\", \\\"3\\\"]}\"}"},
          headers: {
         'Accept'=>'*/*',
         'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
         'Content-Type'=>'application/x-www-form-urlencoded',
         'User-Agent'=>'Faraday v1.3.0'
          }).
        to_return(status: 200, body: "", headers: {})
  end

  it "I see a form with name, description, availability, payment, and price" do
    visit new_host_yard_path

    expect(page).to have_field('name')
    expect(page).to have_field('description')
    expect(page).to have_field('availability')
    expect(page).to have_field('payment')
    expect(page).to have_field('price')
  end

  it "I see a section with address, city, state, zipcode" do
    visit new_host_yard_path

    expect(page).to have_field('street_address')
    expect(page).to have_field('city')
    expect(page).to have_field('state')
    expect(page).to have_field('zipcode')
  end

  it "I see a section to add up to three photo urls" do
    visit new_host_yard_path

    expect(page).to have_field('photo_url_1')
    expect(page).to have_field('photo_url_2')
    expect(page).to have_field('photo_url_3')
  end

  it "I see a section with checkboxes for allowable uses and button to submit" do
    visit new_host_yard_path

    expect(page).to have_content('Select all purposes you will allow others to rent your yard for')
    expect(page).to have_unchecked_field('purposes_1')
    expect(page).to have_unchecked_field('purposes_2')
    expect(page).to have_unchecked_field('purposes_3')
    expect(page).to have_button('Create Yard')
  end

  describe 'happy path' do
    it "when I fill out the form with valid information I can create a yard" do

      visit new_host_yard_path

      fill_in :name, with: "name"
      fill_in :description, with: "description"
      fill_in :availability, with: "availability"
      fill_in :payment, with: "payment"
      fill_in :price, with: 25.20
      fill_in :street_address, with: "street_address"
      fill_in :city, with: "city"
      fill_in :state, with: "state"
      fill_in :zipcode, with: "zipcode"
      fill_in :photo_url_1, with: "https://photo.com/path"
      check "purposes_1"
      check "purposes_3"
      click_button 'Create Yard'

      expect(current_path).to eq(host_dashboard_index_path)
    end
  end

  describe 'sad path' do
    it "when I do not enter a name I cannot create a yard" do

    end

    it "when I do not enter a street address, city, state or zipcode I cannot create a yard" do

    end
  end
end
