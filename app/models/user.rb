class User < ApplicationRecord
  before_create :generate_nickname

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email || "#{auth.uid}@kakao.com"
    end
  end

  private

  def generate_nickname
    self.nickname ||= "user_#{SecureRandom.hex(4)}"
  end
end
