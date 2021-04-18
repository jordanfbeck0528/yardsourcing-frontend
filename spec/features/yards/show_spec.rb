require 'rails_helper'

RSpec.describe "As an authenticated user when I visit the Yard Show Page" do
  before :each do
    user = User.create!(id:1, uid: '123545', username: 'Dominic Padula', email:'thisemail@gmail.com', password: SecureRandom.hex(15) )
    omniauth_response = stub_omniauth_happy('123545', 'Dominic Padula', 'thisemail@gmail.com')
    @user_1 = User.from_omniauth(omniauth_response)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user_1)
    visit new_host_yard_path

    fill_in :name, with: "Yard 1"
    fill_in :description, with: "description"
    fill_in :availability, with: "Mondays"
    fill_in :payment, with: "Venmo"
    fill_in :price, with: 25.00
    fill_in :street_address, with: "street_address"
    fill_in :city, with: "city"
    fill_in :state, with: "state"
    fill_in :zipcode, with: "zipcode"
    fill_in :photo_url_1, with: "https://photo.com/path"
    check "purposes_1"
    check "purposes_3"
    click_button 'Create Yard'
    visit new_host_yard_path

    fill_in :name, with: "Yard 2"
    fill_in :description, with: "description"
    fill_in :availability, with: "Tuesdays"
    fill_in :payment, with: "Venmo"
    fill_in :price, with: 15.00
    fill_in :street_address, with: "street_address"
    fill_in :city, with: "city"
    fill_in :state, with: "state"
    fill_in :zipcode, with: "zipcode"
    fill_in :photo_url_1, with: "https://photo.com/path"
    check "purposes_1"
    check "purposes_3"
    click_button 'Create Yard'
  end
  
  describe "As a host" do
    it "displays the yard's information" do


      visit host_dashboard_index_path
      click_on "Yard 1"

      expect(current_path).to eq('yards/1')
      expect(page).to have_content('Yard 1')
      expect(page).to have_content('description')
      expect(page).to have_content('Mondays')
      expect(page).to have_content('25.50')
    end

    it "displays a button to 'Edit' the yard if the current user is the host" do

      visit host_dashboard_index_path
      click_on "Yard 1"

      expect(current_path).to eq('yards/1')
      expect(page).to have_button('Edit Yard')
    end
  end
  describe "As a renter" do
    xit "displays a button to 'Rent' the yard if the current user is the renter" do
      visit 'yards/4'

      expect(page).to have_button('Rent Yard')
    end
  end
end
