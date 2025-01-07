class User < ApplicationRecord
  has_many :posts

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]
  acts_as_paranoid # For soft delete

  def self.from_omniauth(auth)
    # Ne pas inclure les utilisateurs supprimés dans la recherche
    user = where(email: auth.info.email, deleted_at: nil).first

    if user.nil?
      # Créer un nouvel utilisateur avec un nouveau ID même si un email supprimé existe
      user = create!(
        email: auth.info.email,
        password: Devise.friendly_token[0, 20],
        provider: auth.provider,
        uid: auth.uid,
        full_name: auth.info.name,
        avatar_url: auth.info.image
      )
    end

    user
  end
end
