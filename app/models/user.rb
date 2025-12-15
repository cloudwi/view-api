# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null  # 이메일 주소
#  encrypted_password     :string           default(""), not null  # 암호화된 비밀번호
#  name                   :string                                  # 사용자 이름
#  nickname               :string                                  # 자동 생성되는 닉네임 (고유)
#  profile_image          :string                                  # 프로필 이미지 URL
#  provider               :string                                  # OAuth 제공자 (kakao 등)
#  uid                    :string                                  # OAuth 제공자의 사용자 ID
#  remember_created_at    :datetime                                # 로그인 기억 생성 시각
#  reset_password_sent_at :datetime                                # 비밀번호 재설정 메일 발송 시각
#  reset_password_token   :string                                  # 비밀번호 재설정 토큰
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes:
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_nickname              (nickname) UNIQUE
#  index_users_on_provider_and_uid      (provider,uid) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  before_create :generate_nickname

  has_many :views, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :votes, dependent: :destroy

  validates :nickname, uniqueness: true, allow_nil: true

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email || "#{auth.uid}@kakao.com"
    end
  end

  private

  def generate_nickname
    self.nickname = NicknameGenerator.generate
  end
end
