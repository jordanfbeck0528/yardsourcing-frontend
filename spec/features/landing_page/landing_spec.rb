require 'rails_helper'

RSpec.describe 'Welcome Page' do
  describe 'When I visit the Root path' do
    it 'displays absolutely sick text to pull our Users in and get data' do
      visit root_path
      expect(page).to have_content('This is YardSourcing')
      expect(page).to have_content("You need yards, and we got 'em")
    end
  end

  describe 'sad path ' do
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
      user = User.create!(id:1, uid: '123545', username: 'Dominic Padula', email:'thisemail@gmail.com')
      omniauth_response = stub_omniauth_happy('123545', 'Dominic Padula', 'thisemail@gmail.com')
      user_1 = User.from_omniauth(omniauth_response)
      response = File.open("spec/fixtures/host_yards.json")

      VCR.use_cassette('renters/dash/landing_page') do
        visit root_path

        click_button 'Login through Google'
        expect(page).to have_content("Welcome #{user_1.username}")
        expect(current_path).to eq(renter_dashboard_index_path)
      end
    end
  end 


    describe 'After I am logged in, there is a button to logout' do
    it 'logs user out' do
      user = User.create!(id:1, uid: '123545', username: 'Dominic Padula', email:'thisemail@gmail.com')
      omniauth_response = stub_omniauth_happy('123545', 'Dominic Padula', 'thisemail@gmail.com')
      user_1 = User.from_omniauth(omniauth_response)
      response = File.open("spec/fixtures/host_yards.json")

      VCR.use_cassette('renters/dash/landing_page') do
        visit root_path

        click_button 'Login through Google'
        click_button 'Logout'
        expect(page).to have_content("You have been logged out.")
        expect(current_path).to eq(root_path)
      end
    end
  end
end
