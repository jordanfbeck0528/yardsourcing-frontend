require 'rails_helper'

RSpec.describe 'Registration Page' do
  describe 'registration page has a form for users to fill out' do
    it 'when we click register button it brings us to registration' do
      visit root_path
      click_button 'Register'
      expect(current_path).to eq(registration_path)
      expect(page).to have_content('Registration Page')
    end

    it "has a content to fill out a form and register" do
      visit registration_path
      expect(page).to have_field('Username')
      expect(page).to have_field('Email')
      expect(page).to have_field('Password')
      expect(page).to have_field('Password Confirmation')
    end

    it "can create users" do
      visit registration_path

      username = "funbucket13"
      email = 'funbuck@gmail.com'
      password = "test"
      fill_in :username, with: username
      fill_in :email, with: email
      fill_in :password, with: password
      fill_in :password_confirmation, with: password
      click_on 'Register'

      expect(page).to have_content("Welcome, #{username}!")
    end
  end

  describe 'sad path' do
    it 'errors out with missing fields' do
      visit registration_path

      username = "funbucket13"
      email = 'funbuck@gmail.com'
      password = "test"
      fill_in :username, with: username
      fill_in :password, with: password
      fill_in :password_confirmation, with: password
      click_on 'Register'
      expect(current_path).to eq(registration_path)
      expect(page).to have_content('You are missing fields. Both passwords must match.')
    end

    it 'errors out when we are missing user name' do
      visit registration_path
      username = "funbucket13"
      email = 'funbuck@gmail.com'
      password = "test"
      fill_in :email, with: email
      fill_in :password, with: password
      fill_in :password_confirmation, with: password
      click_on 'Register'
      expect(current_path).to eq(registration_path)
      expect(page).to have_content('You are missing fields. Both passwords must match.')
    end

    it 'errors out when passwords are different' do
      visit registration_path

      username = "funbucket13"
      email = 'funbuck@gmail.com'
      password = "test"
      fill_in :username, with: username
      fill_in :email, with: email
      fill_in :password, with: password
      fill_in :password_confirmation, with: 'bad pass'
      click_on 'Register'
      expect(current_path).to eq(registration_path)
      expect(page).to have_content('You are missing fields. Both passwords must match.')
    end
  end
end
