require 'rails_helper'

RSpec.describe "As an authenticated user when I visit the Yard Show Page" do
  before :each do
    user = User.create!(id:1, uid: '123545', username: 'Dominic Padula', email:'thisemail@gmail.com', password: SecureRandom.hex(15) )
    omniauth_response = stub_omniauth_happy('123545', 'Dominic Padula', 'thisemail@gmail.com')
    @user_1 = User.from_omniauth(omniauth_response)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user_1)
    visit new_host_yard_path
  end

  describe "As a host" do
    it "displays the yard's information" do
      VCR.use_cassette('host_yard_show_page_ultimate_party') do
        visit host_dashboard_index_path
        click_on "Ultimate Party Yard"

        expect(current_path).to eq('yards/1')
        expect(page).to have_content('Ultimate Party Yard')
        expect(page).to have_content('This yard is equiped with a firepit, a pool, and a pool house to accommodate all your party needs.')
        expect(page).to have_content('123 4th St, Denver, CO, 80202')
        expect(page).to have_content('pet rental')
      end
    end

    it "displays a button to 'Edit' the yard if the current user is the host" do
      VCR.use_cassette('host_yard_show_page_ultimate_party') do
        visit host_dashboard_index_path
        click_on "Ultimate Party Yard"

        expect(current_path).to eq('yards/1')
        expect(page).to have_button('Edit Yard')
      end
    end
    xit "displays the yard's information" do
      VCR.use_cassette('host_yard_show_page_hobby') do
        visit host_dashboard_index_path
        click_on "Large Yard for any Hobby"

        expect(current_path).to eq('yards/2')
        expect(page).to have_content('Large Yard for any Hobby')
        expect(page).to have_content('A large backyard close to the city. Equiped with a barbeque.')
        expect(page).to have_content('20 Main St, Denver, CO, 80202')
        expect(page).to have_content('25.50')
      end
    end

    xit "displays a button to 'Edit' the yard if the current user is the host" do

      VCR.use_cassette('host_yard_show_page_hobby') do
        visit host_dashboard_index_path
        click_on "Large Yard for any Hobby"

        expect(current_path).to eq('yards/2')
        expect(page).to have_button('Edit Yard')
      end
    end
  end
  describe "As a renter" do
    xit "displays a button to 'Rent' the yard if the current user is the renter" do
      visit 'yards/4'

      expect(page).to have_button('Rent Yard')
    end
  end
end
