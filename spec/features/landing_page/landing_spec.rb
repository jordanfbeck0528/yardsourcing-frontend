require 'rails_helper'

RSpec.describe 'Welcome Page' do
  describe 'When I visit the Root path' do
    it 'displays absolutely sick text to pull our Users in and get data' do
      visit root_path
      expect(page).to have_content('This is YardSourcing')
      expect(page).to have_content("You need yards, and we got 'em")
    end
  end

  describe 'it has an sad path ' do
    it 'has returns to home page if credentials are bad' do
      stub_omniauth_sad
      visit root_path

      click_button 'Login through Google'
      expect(page).to have_content('Sorry, your credentials are bad.')
      expect(current_path).to eq('/')
    end
  end

  describe 'happy path' do
    it 'brings us to the correct page if google credentials are good' do
      user = User.create(id:1, uid: 123545, username: 'Dominic Padula', email:'thisemail@gmail.com', password: SecureRandom.hex(15) )
      stub_omniauth_happy
      response = File.open("spec/fixtures/host_yards.json")

      stub_request(:get, "https://localhost:3001/api/v1/hosts/1/yards").
         with(
           headers: {
       	  'Accept'=>'*/*',
       	  'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	  'User-Agent'=>'Faraday v1.3.0'
           }).
         to_return(status: 200, body: response, headers: {})
      visit root_path

      click_button 'Login through Google'
      expect(page).to have_content('Welcome Dominic Padula')
      expect(current_path).to eq('/host/dashboard')
    end
  end
end
