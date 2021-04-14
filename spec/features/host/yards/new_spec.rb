require 'rails_helper'

describe 'As an authenticated user when I visit the new yard page' do
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
    expect(page).to have_content('Purposes:')#checkboxes go here thus said Doug
    expect(page).to have_button('Create Yard')
  end

  describe 'happy path' do
    it "when I fill out the form with valid information I can create a yard" do

    end
  end

  describe 'sad path' do
    it "when I do not enter a name I cannot create a yard" do

    end

    it "when I do not enter a street address, city, state or zipcode I cannot create a yard" do

    end
  end
end
