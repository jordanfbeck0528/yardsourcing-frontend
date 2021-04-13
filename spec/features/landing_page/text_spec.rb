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
  end
end
