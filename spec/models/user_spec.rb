require 'rails_helper'

RSpec.describe User, type: :model do
  describe '.from_omniauth' do
    let(:auth) do
      OmniAuth::AuthHash.new(
        provider: 'google_oauth2',
        uid: '123456789',
        info: {
          email: 'test@example.com',
          name: 'Test User',
          image: 'http://example.com/avatar.png'
        }
      )
    end

    context 'when a user with the same email exists and is not deleted' do
      let!(:existing_user) { create(:user, email: 'test@example.com', deleted_at: nil) }

      it 'returns the existing user' do
        user = User.from_omniauth(auth)
        expect(user).to eq(existing_user)
      end
    end

    context 'when a user with the same email exists but is soft deleted' do
      let!(:deleted_user) { create(:user, email: 'test@example.com', deleted_at: Time.current) }

      it 'creates a new user with the same email but a new ID' do
        user = User.from_omniauth(auth)
        expect(user).to_not eq(deleted_user)
        expect(user.email).to eq('test@example.com')
        expect(user.deleted_at).to be_nil
      end
    end

    context 'when no user with the email exists' do
      it 'creates a new user' do
        expect {
          User.from_omniauth(auth)
        }.to change(User, :count).by(1)

        user = User.last
        expect(user.email).to eq('test@example.com')
        expect(user.full_name).to eq('Test User')
        expect(user.avatar_url).to eq('http://example.com/avatar.png')
        expect(user.provider).to eq('google_oauth2')
        expect(user.uid).to eq('123456789')
      end
    end
  end
end
