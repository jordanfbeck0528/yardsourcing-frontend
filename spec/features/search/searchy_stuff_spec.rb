require 'rails_helper'

RSpec.describe 'Search Page' do
  describe 'happy path' do
    before :each do
      user = User.create!(id:1, uid: '123545', username: 'Dominic Padula', email:'thisemail@gmail.com' )
      omniauth_response = stub_omniauth_happy('123545', 'Dominic Padula', 'thisemail@gmail.com')
      @user_1 = User.from_omniauth(omniauth_response)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user_1)
    end

    it 'displays text and form' do
      VCR.use_cassette('all_purposes') do
        visit search_index_path
        expect(page).to have_content("Find your dream yard:")
        expect(page).to have_content("Where will you yard?")
        expect(page).to have_content("How will you spend your time yarding?")
        expect(page).to have_content('Pet Rental')
        expect(page).to have_content('Party Rental')
        expect(page).to have_content('Hobby Rental')
      end
    end

    it 'displays form with location prefilled in' do
      VCR.use_cassette('all_purposes2') do
        purposes = EngineService.all_purposes
        visit search_index_path
        expect(page).to have_field('location')
        expect(page).to have_unchecked_field("#{purposes[:data][0][:attributes][:name].titleize}")
        expect(page).to have_unchecked_field("#{purposes[:data][1][:attributes][:name].titleize}")
        expect(page).to have_unchecked_field("#{purposes[:data][2][:attributes][:name].titleize}")
        expect(page).to have_button('Yard Me')
      end
    end

    it "when filled in the form brings you to the yards/search" do
      VCR.use_cassette('all_purposes_create_search') do
        visit search_index_path
        fill_in :location, with: '80205'
        click_button 'Yard Me'
        expect(current_path).to eq('/search/yards')
        expect(page).to have_content("Ultimate Party Yard")
        expect(page).to have_content('Multipurpose Yard')
      end
    end

    it 'slims the data with purposes' do
      VCR.use_cassette('all_purposes_create_search_with_purpose') do
        purposes = EngineService.all_purposes
        visit search_index_path
        fill_in :location, with: '80205'
        check "#{purposes[:data][0][:attributes][:name].titleize}"
        click_button 'Yard Me'
        expect(current_path).to eq('/search/yards')
        expect(page).to have_content("Ultimate Party Yard")
        expect(page).not_to have_content('Large Yard for any Hobby')
        expect(page).not_to have_content('Multipurpose Yard')
      end
    end
  end

  describe 'sad path' do
    it 'errors out when you do not enter valid zip code' do
      VCR.use_cassette('all_purposes_bad_zip_search') do
        purposes = EngineService.all_purposes
        visit search_index_path
        fill_in :location, with: '802'
        check "#{purposes[:data][0][:attributes][:name].titleize}"
        click_button 'Yard Me'
        expect(page).to have_content('Invalid zipcode')
        expect(page).to have_content("Find your dream yard:")
        expect(page).to have_content("Where will you yard?")
        expect(page).to have_content("How will you spend your time yarding?")
      end
    end

    it 'errors out when you enter a zipcode that is too long' do
      VCR.use_cassette('all_purposes_long_search_zip') do
        purposes = EngineService.all_purposes
        visit search_index_path
        fill_in :location, with: '8021902'
        check "#{purposes[:data][0][:attributes][:name].titleize}"
        click_button 'Yard Me'
        expect(page).to have_content('Invalid zipcode')
        expect(page).to have_content("Find your dream yard:")
        expect(page).to have_content("Where will you yard?")
        expect(page).to have_content("How will you spend your time yarding?")
      end
    end
  end
end
