require 'rails_helper'

RSpec.describe User, :type => :model do
  describe 'validations' do
    it { should validate_uniqueness_of(:username)}
    it { should validate_presence_of(:password).on(:create) }
    it { should have_secure_password }

  end

  describe User, '.authenticate' do
    it "authenticates username and password" do
      user = create(:user, username: 'User@example.com', password: 'secret123')
      result = User.authenticate('user@example.com', 'secret123')
      expect(result).to eq(user)
    end

    it 'return false if there is no matchs' do
      create(:user, username: 'user@example.com', password: 'no-matched')
      result = User.authenticate('no_user@example.com', 'secret123')
      expect(result).to eq(false)
    end
  end

  describe User, '#change_password' do
    let(:user) { create(:user, username: 'vicheka', password: 'password')}
    context 'with valid passsword' do
      it "return true" do
        result = user.change_password('password', 'new_password', 'new_password')
        expect(result).to eq true
      end
    end

    context 'with invalid password' do
      it 'return false with Old password does not matched error message' do
        result = user.change_password('incorrect', 'new_password', 'new_password')
        expect(result).to eq false
        expect(user.errors.full_messages).to eq ["Old password does not matched"]
      end

      it 'return false with password does not matched' do
        result = user.change_password('password', 'missmatch', 'password')
        expect(user.errors.full_messages).to eq ["Password confirmation doesn't match Password"]
        expect(result).to eq false
      end
    end
  end

  describe User, '.hc_worker?' do
    context 'User from HC match phone_number' do
      it "return true" do
        hc = create(:hc)
        user = create(:user, phone: '0975553553', place: hc)
        expect(User.hc_worker?('855975553553')).to eq(true)
      end
    end

    context 'User not from HC not match phone_number' do
      it "return false" do
        hc = create(:hc)
        user = create(:user, phone: '0975555555', place: hc)
        expect(User.hc_worker?('855975553553')).to eq(false)
      end
    end

    context 'User not from HC match phone_number' do
      it "return false" do
        phd = create(:phd)
        user = create(:user, phone: '0975555555', place: phd)
        expect(User.hc_worker?('855975555555')).to eq(false)
      end
    end

  end

end
