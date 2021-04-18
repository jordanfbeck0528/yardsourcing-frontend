require 'rails_helper'

describe 'As an authenticated user when I visit the new yard page' do
  before :each do
    # stub omniauth user login
    user = User.create!(id:1, uid: '123545', username: 'Dominic Padula', email:'thisemail@gmail.com', password: SecureRandom.hex(15) )
    omniauth_response = stub_omniauth_happy('123545', 'Dominic Padula', 'thisemail@gmail.com')
    @user_1 = User.from_omniauth(omniauth_response)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user_1)

    # yard_response = File.open("spec/fixtures/host_yards.json")
    # stub_request(:get, "https://localhost:3001/api/v1/hosts/#{@user_1.id}/yards").
    #   with(
    #     headers: {
    #    'Accept'=>'*/*',
    #    'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
    #    'User-Agent'=>'Faraday v1.3.0'
    #     }).
    #   to_return(status: 200, body: yard_response, headers: {})
    #
    # purpose_response = File.open("spec/fixtures/all_purposes.json")
    # stub_request(:get, "https://localhost:3001/api/v1/purposes").
    #   with(
    #     headers: {
    #    'Accept'=>'*/*',
    #    'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
    #    'User-Agent'=>'Faraday v1.3.0'
    #     }).
    #   to_return(status: 200, body: purpose_response, headers: {})

    # stub_request(:post, "https://localhost:3001/api/v1/yards").
    #   with(
    #     body: {"{\"yard\":\"{\\\"host_id\\\""=>">#{@user_1.id}, \\\"name\\\"=>\\\"name\\\", \\\"description\\\"=>\\\"description\\\", \\\"availability\\\"=>\\\"availability\\\", \\\"payment\\\"=>\\\"payment\\\", \\\"price\\\"=>\\\"25.2\\\", \\\"street_address\\\"=>\\\"street_address\\\", \\\"city\\\"=>\\\"city\\\", \\\"state\\\"=>\\\"state\\\", \\\"zipcode\\\"=>\\\"zipcode\\\", \\\"photo_url_1\\\"=>\\\"https://photo.com/path\\\", \\\"photo_url_2\\\"=>\\\"\\\", \\\"photo_url_3\\\"=>\\\"\\\", \\\"purposes\\\"=>[\\\"1\\\", \\\"3\\\"]}\"}"},
    #     headers: {
    #    'Accept'=>'*/*',
    #    'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
    #    'Content-Type'=>'application/x-www-form-urlencoded',
    #    'User-Agent'=>'Faraday v1.3.0'
    #     }).
    #   to_return(status: 200, body: "", headers: {})
  end

  it "I see a form with name, description, availability, payment, and price" do
    VCR.use_cassette('all_purposes') do
      visit new_host_yard_path

      expect(page).to have_field('name')
      expect(page).to have_field('description')
      expect(page).to have_field('availability')
      expect(page).to have_field('payment')
      expect(page).to have_field('price')
    end
  end

  it "I see a section with address, city, state, zipcode" do
    VCR.use_cassette('all_purposes') do
      visit new_host_yard_path

      expect(page).to have_field('street_address')
      expect(page).to have_field('city')
      expect(page).to have_field('state')
      expect(page).to have_field('zipcode')
    end
  end

  it "I see a section to add up to three photo urls" do
    VCR.use_cassette('all_purposes') do
      visit new_host_yard_path

      expect(page).to have_field('photo_url_1')
      expect(page).to have_field('photo_url_2')
      expect(page).to have_field('photo_url_3')
    end
  end

  it "I see a section with checkboxes for allowable uses and button to submit" do
    VCR.use_cassette('all_purposes') do
      visit new_host_yard_path

      expect(page).to have_content('Select all purposes you will allow others to rent your yard for')
      expect(page).to have_unchecked_field('purposes_1')
      expect(page).to have_unchecked_field('purposes_2')
      expect(page).to have_unchecked_field('purposes_3')
      expect(page).to have_button('Create Yard')
    end
  end

  describe 'happy path' do
    it "when I fill out the form with valid information I can create a yard" do
      VCR.use_cassette('create_yard') do
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
        # require "pry"; binding.pry
        expect(current_path).to eq(host_yard_path(6))
      end
    end
  end

  describe 'sad path' do
    it "when I do not enter a name I cannot create a yard" do

    end

    it "when I do not enter a street address, city, state or zipcode I cannot create a yard" do

    end
  end
end
