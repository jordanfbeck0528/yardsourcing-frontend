require 'rails_helper'

RSpec.describe 'Welcome Page' do
  describe 'When I visit the Root path' do
    it 'displays absolutely sick text to pull our Users in and get data' do
      visit root_path
      expect(page).to have_content('This is YardSourcing')
      expect(page).to have_content("You need yards, and we got 'em")
    end

    it "displays a login form for previously existing Users" do
      visit root_path
      expect(page).to have_button('Log In')
      expect(page).to have_content('Email:')
      expect(page).to have_content('Password:')
    end

    it "can log in users through our database and bring them to dashboard" do
      user = User.create!(username: 'Domo', password: 'test', email: 'domo@gmail.com')
      visit root_path
      fill_in 'email', with: user.email
      fill_in 'password', with: user.password
      click_button('Log In')
      expect(current_path).to eq(user_path(user.id))
      expect(page).to have_content('Welcome, Domo')
    end

    it "shows a button to register to our site " do
      visit root_path
      expect(page).to have_button('Register')
    end
  end

  describe "sad path for invalid login" do
    it "re renders page and shows an error message " do
      visit root_path
      user = User.create!(username: 'Domo', password: 'test', email: 'domo@gmail.com')
      fill_in 'email', with: 'user'
      fill_in 'password', with: 'pass'
      click_button('Log In')
      expect(current_path).to eq(root_path)
      expect(page).to have_content('Sorry, your credentials are bad')
    end
  end
end
