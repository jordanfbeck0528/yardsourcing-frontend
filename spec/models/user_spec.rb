require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    it { should validate_presence_of :username }
    it { should validate_presence_of :email }
    it { should validate_uniqueness_of :email }
    it { should validate_uniqueness_of :username }
  end

  describe 'class methods' do
    describe '::from_omniauth' do
      it "finds existing user or creates based on omniauth response" do
        response = stub_omniauth_happy('123545', 'Dominic Padula', 'thisemail@gmail.com')
        uid = response[:uid]

        expect(User.find_by(uid: uid)).to be_nil

        user = User.from_omniauth(response)
        expect(user.uid).to eq(uid)
        expect(User.from_omniauth(response).id).to eq(user.id)
      end
    end
  end
end
