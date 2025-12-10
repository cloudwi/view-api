class User < ApplicationRecord
  devise :omniauthable, omniauth_providers: [ :kakao ]

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email || "#{auth.uid}@kakao.com"
      user.name = auth.info.name
      user.profile_image = auth.info.image
    end
  end
end
