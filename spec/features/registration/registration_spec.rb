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
  end
end
