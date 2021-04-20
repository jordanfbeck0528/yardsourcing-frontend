require 'rails_helper'

describe 'As an authenticated user when I visit the edit yard page' do
  before :each do
    user = User.create!(id:1, uid: '123545', username: 'Dominic Padula', email:'thisemail@gmail.com')
    omniauth_response = stub_omniauth_happy('123545', 'Dominic Padula', 'thisemail@gmail.com')
    @user_1 = User.from_omniauth(omniauth_response)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user_1)
  end

  describe "happy path" do
    VCR.use_cassette('edit_yard_happy') do
      it "I see a form prepopulated with the yards stored information" do
        visit yard_path(2)
        click_on "Edit Yard"

        expect(page).to have_field('name')
        expect(page).to have_field('description')
        expect(page).to have_field('availability')
        expect(page).to have_field('payment')
        expect(page).to have_field('price')
        expect(page).to have_field('street_address')
        expect(page).to have_field('city')
        expect(page).to have_field('state')
        expect(page).to have_field('zipcode')
        expect(page).to have_field('photo_url_1')
        expect(page).to have_field('photo_url_2')
        expect(page).to have_field('photo_url_3')
        expect(page).to have_content('Select all purposes you will allow others to rent your yard for')
        expect(page).to have_unchecked_field('purposes_1')
        expect(page).to have_unchecked_field('purposes_2')
        expect(page).to have_unchecked_field('purposes_3')
        expect(page).to have_button('Update Yard')
        expect(page).to have_content('Ultimate Party Yard')
      end
    end
    it "When the form is submitted it updates the yard" do
      VCR.use_cassette('edit_yard_happy_submit') do
        visit yard_path(2)
        click_on "Edit Yard"

        fill_in :name, with: "PaRtY HoUsE!!"
        fill_in :description, with: "description"
        fill_in :availability, with: "availability"
        fill_in :payment, with: "cash cash cash"
        fill_in :price, with: 125.20
        fill_in :street_address, with: "street_address"
        fill_in :city, with: "city"
        fill_in :state, with: "state"
        fill_in :zipcode, with: "zipcode"
        fill_in :photo_url_1, with: "https://jalbum.net/.workspace/slides/shaun-montero-ZxDX8D9HHNM-unsplash.jpg"
        check "purposes_1"
        check "purposes_3"
        click_button 'Update Yard'

        expect(page).to have_content("PaRtY HoUsE!!")

        visit yard_path(2)
        click_on "Edit Yard"


        fill_in :name, with: "Ultimate Party Yard"
        check "purposes_1"
        check "purposes_3"
        click_button 'Update Yard'
        expect(page).to have_content('Ultimate Party Yard')
      end
    end
  end
  describe "sad path" do
    it "flashes an error message when a name is left blank" do
      VCR.use_cassette('edit_yard_sad_no_name') do
        visit edit_host_yard_path(2)

        check "purposes_1"
        fill_in :name, with: ""
        click_button 'Update Yard'

        expect(current_path).to eq(host_yard_path(2))
      end
    end
    it "flashes an error message when a street_address is left blank" do
      VCR.use_cassette('edit_yard_sad_no_street') do
        visit edit_host_yard_path(2)
        check "purposes_1"
        fill_in :street_address, with: ""

        expect(current_path).to eq(edit_host_yard_path(2))
      end
    end
    it "flashes an error message when a city is left blank" do
      VCR.use_cassette('edit_yard_sad_no_city') do
        visit edit_host_yard_path(2)
        check "purposes_1"
        fill_in :city, with: ""

        expect(current_path).to eq(edit_host_yard_path(2))
      end
    end
    it "flashes an error message when a state is left blank" do
      VCR.use_cassette('edit_yard_sad_no_state') do
        visit edit_host_yard_path(2)
        check "purposes_1"
        fill_in :state, with: ""

        expect(current_path).to eq(edit_host_yard_path(2))
      end
    end
    it "flashes an error message when a zipcode is left blank" do
      VCR.use_cassette('edit_yard_sad_no_zipcode') do
        visit edit_host_yard_path(2)
        check "purposes_1"
        fill_in :zipcode, with: ""

        expect(current_path).to eq(edit_host_yard_path(2))
      end
    end
    it "flashes an error message when a description is left blank" do
      VCR.use_cassette('edit_yard_sad_no_description') do
        visit edit_host_yard_path(2)
        check "purposes_1"
        fill_in :description, with: ""

        expect(current_path).to eq(edit_host_yard_path(2))
      end
    end
    it "flashes an error message when a availability is left blank" do
      VCR.use_cassette('edit_yard_sad_no_availability') do
        visit edit_host_yard_path(2)
        check "purposes_1"
        fill_in :availability, with: ""

        expect(current_path).to eq(edit_host_yard_path(2))
      end
    end
    it "flashes an error message when a payment is left blank" do
      VCR.use_cassette('edit_yard_sad_no_payment') do
        visit edit_host_yard_path(2)
        check "purposes_1"
        fill_in :payment, with: ""

        expect(current_path).to eq(edit_host_yard_path(2))
      end
    end
    it "flashes an error message when a purpose is not selected" do
      VCR.use_cassette('edit_yard_sad_no_purposes') do
        visit edit_host_yard_path(2)

        expect(current_path).to eq(edit_host_yard_path(2))
      end
    end
  end
end
