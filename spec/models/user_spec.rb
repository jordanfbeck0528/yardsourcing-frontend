require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    it { should validate_presence_of :username }
    it { should validate_presence_of :email }
    it { should validate_uniqueness_of :email }
    it { should validate_uniqueness_of :username }
    it { should validate_presence_of :password }
    it { should validate_confirmation_of :password }
  end

  describe 'class methods' do
    describe '::from_omniauth' do
      it "finds existing user or creates based on omniauth response" do
        uid = stub_omniauth_happy[:uid]
        response = stub_omniauth_happy

        expect(User.find_by(uid: uid)).to be_nil

        user = User.from_omniauth(response)
        expect(user.uid).to eq(uid)
        expect(User.from_omniauth(response).id).to eq(user.id)
      end
    end
  end
end
