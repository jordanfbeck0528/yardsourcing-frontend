require 'rails_helper'

RSpec.describe 'Search Page' do
  describe 'happy path' do
    before :each do
      user = User.create!(id:1, uid: '123545', username: 'Dominic Padula', email:'thisemail@gmail.com' )
      omniauth_response = stub_omniauth_happy('123545', 'Dominic Padula', 'thisemail@gmail.com')
      @user_1 = User.from_omniauth(omniauth_response)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user_1)
      VCR.use_cassette('search/all_purposes') do
        @purpose_info = purposes = EngineService.all_purposes
      end
      @purposes = @purpose_info[:data].map do |obj_info|
        OpenStruct.new({ id: obj_info[:id],
          name: obj_info[:attributes][:name].titleize})
      end
    end

    it 'displays text and form' do
      VCR.use_cassette('search/search_80205_yards') do
        search_params = {location: '80205'}
        visit search_yards_path(search_params)

        expect(page).to have_content("Search for more dream yards:")
        expect(page).to have_content("Enter the zipcode where you want to yard:")
        expect(page).to have_content("How will you spend your time yarding?")
        expect(page).to have_content('Pet Rental')
        expect(page).to have_content('Party Rental')
        expect(page).to have_content('Hobby Rental')
      end
    end

    it 'displays form with location prefilled in' do
      VCR.use_cassette('search/search_80205_yards') do
        search_params = {location: '80205'}
        visit search_yards_path(search_params)

        expect(page).to have_field('location')
        expect(page).to have_unchecked_field("#{@purposes.first.name.titleize}")
        expect(page).to have_unchecked_field("#{@purposes.second.name.titleize}")
        expect(page).to have_unchecked_field("#{@purposes.last.name.titleize}")
        expect(page).to have_button('Yard Me')
      end
    end

    it "when filled in the form brings you to the yards/search" do
      VCR.use_cassette('search/search_yard_new_search_results') do
        search_params = {location: '80205'}
        visit search_yards_path(search_params)

        expect(page).to have_content("Ultimate Party Yard")
        expect(page).to have_content('Multipurpose Yard')

        fill_in :location, with: '72034'
        check 'Party Rental'
        click_button 'Yard Me'

        expect(page).to_not have_content("Ultimate Party Yard")
        expect(page).to have_content('Country')
      end
    end
  end
end
