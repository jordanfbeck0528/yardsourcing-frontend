require 'rails_helper'
describe 'As an authenticated user when I visit the new yard page' do
  before :each do
    # stub omniauth user login
    user = User.create!(id:1, uid: '123545', username: 'Dominic Padula', email:'thisemail@gmail.com', password: SecureRandom.hex(15) )
    omniauth_response = stub_omniauth_happy('123545', 'Dominic Padula', 'thisemail@gmail.com')
    @user_1 = User.from_omniauth(omniauth_response)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user_1)
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
        fill_in :name, with: "A new yard!!"
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
        expect(page).to have_content("A new yard!!")
      end
    end
  end

  describe 'sad path' do
    it "when I do not enter a name I cannot create a yard" do
      VCR.use_cassette('all_purposes') do
        VCR.use_cassette('bad-yard') do
          visit new_host_yard_path
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
          expect(page).to have_content("Validation failed: Name can't be blank")
        end
      end
    end
    it "when I do not enter a street address I cannot create a yard" do
      VCR.use_cassette('all_purposes') do
        VCR.use_cassette('bad-yard-address') do
          visit new_host_yard_path
          fill_in :name, with: "A new yard!!"
          fill_in :description, with: "description"
          fill_in :availability, with: "availability"
          fill_in :payment, with: "payment"
          fill_in :price, with: 25.20
          fill_in :city, with: "city"
          fill_in :state, with: "state"
          fill_in :zipcode, with: "zipcode"
          fill_in :photo_url_1, with: "https://photo.com/path"
          check "purposes_1"
          check "purposes_3"
          click_button 'Create Yard'
          expect(page).to have_content("Validation failed: Street address can't be blank")
        end
      end
    end

    it 'errors out and errors out when I do not enter city and cannot create yard' do
      VCR.use_cassette('all_purposes') do
        VCR.use_cassette('bad-yard-city') do
          visit new_host_yard_path
          fill_in :name, with: "A new yard!!"
          fill_in :description, with: "description"
          fill_in :availability, with: "availability"
          fill_in :payment, with: "payment"
          fill_in :price, with: 25.20
          fill_in :street_address, with: "street_address"
          fill_in :state, with: "state"
          fill_in :zipcode, with: "zipcode"
          fill_in :photo_url_1, with: "https://photo.com/path"
          check "purposes_1"
          check "purposes_3"
          click_button 'Create Yard'
          expect(page).to have_content("Validation failed: City can't be blank")
        end
      end
    end

    it 'errors out when I do not enter state' do
      VCR.use_cassette('all_purposes') do
        VCR.use_cassette('bad-yard-state') do
          visit new_host_yard_path
          fill_in :name, with: "A new yard!!"
          fill_in :description, with: "description"
          fill_in :availability, with: "availability"
          fill_in :payment, with: "payment"
          fill_in :price, with: 25.20
          fill_in :street_address, with: "street_address"
          fill_in :city, with: "city"
          fill_in :zipcode, with: "zipcode"
          fill_in :photo_url_1, with: "https://photo.com/path"
          check "purposes_1"
          check "purposes_3"
          click_button 'Create Yard'
          expect(page).to have_content("Validation failed: State can't be blank")
        end
      end
    end

    it 'errors out when I do not enter zipcode' do
      VCR.use_cassette('all_purposes') do
        VCR.use_cassette('bad-yard-zip') do
          visit new_host_yard_path
          fill_in :name, with: "A new yard!!"
          fill_in :description, with: "description"
          fill_in :availability, with: "availability"
          fill_in :payment, with: "payment"
          fill_in :price, with: 25.20
          fill_in :street_address, with: "street_address"
          fill_in :city, with: "city"
          fill_in :state, with: "state"
          fill_in :photo_url_1, with: "https://photo.com/path"
          check "purposes_1"
          check "purposes_3"
          click_button 'Create Yard'
          expect(page).to have_content("Validation failed: Zipcode can't be blank")
        end
      end
    end

    it 'errors out when I do not enter 1 purpose ' do
      VCR.use_cassette('create_yard') do
        VCR.use_cassette('bad-yard-purposes') do
          visit new_host_yard_path
          fill_in :name, with: "A new yard!!"
          fill_in :description, with: "description"
          fill_in :availability, with: "availability"
          fill_in :payment, with: "payment"
          fill_in :price, with: 25.20
          fill_in :street_address, with: "street_address"
          fill_in :city, with: "city"
          fill_in :state, with: "state"
          fill_in :zipcode, with: "zipcode"
          fill_in :photo_url_1, with: "https://photo.com/path"
          click_button 'Create Yard'
          expect(page).to have_content("You must select at least one purpose")
        end
      end
    end
  end
end
