class User < ApplicationRecord
  before_create :generate_nickname

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email || "#{auth.uid}@kakao.com"
    end
  end

  private

  def generate_nickname
    adjectives = %w[
      행복한 즐거운 신나는 멋진 귀여운 용감한 지혜로운 활발한 상냥한 든든한
      빛나는 따뜻한 시원한 달콤한 상큼한 포근한 씩씩한 깜찍한 당당한 유쾌한
      느긋한 재빠른 영리한 다정한 명랑한 활기찬 산뜻한 화사한 청량한 건강한
    ]

    nouns = %w[
      탕수육 치킨 피자 햄버거 떡볶이 김밥 라면 초밥 파스타 스테이크
      고양이 강아지 토끼 판다 호랑이 사자 여우 곰돌이 펭귄 코알라
      우주인 탐험가 요리사 마법사 과학자 예술가 음악가 몽상가 모험가 발명가
    ]

    self.nickname ||= "#{adjectives.sample} #{nouns.sample}"
  end
end
