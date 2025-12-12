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
    loop do
      self.nickname = build_nickname
      break unless User.exists?(nickname: nickname)
    end
  end

  def build_nickname
    patterns = [
      -> { "#{adjective} #{noun}" },
      -> { "#{noun} #{verb} #{noun2}" },
      -> { "#{adverb} #{verb} #{noun}" },
      -> { "#{noun}#{suffix}" },
      -> { "#{time} #{number}시 #{noun}" },
      -> { "#{place} #{noun} #{role}" }
    ]

    patterns.sample.call
  end

  def adjective
    %w[
      행복한 즐거운 신나는 멋진 귀여운 용감한 지혜로운 활발한 상냥한 든든한
      빛나는 따뜻한 시원한 달콤한 상큼한 포근한 씩씩한 깜찍한 당당한 유쾌한
      졸린 배고픈 심심한 설레는 두근두근 반짝반짝 몽글몽글 말랑말랑 쫄깃쫄깃
    ].sample
  end

  def noun
    %w[
      탕수육 치킨 피자 햄버거 떡볶이 김밥 라면 초밥 파스타 스테이크
      고양이 강아지 토끼 판다 호랑이 사자 여우 곰돌이 펭귄 코알라
      수박 망고 딸기 바나나 아보카도 당근 브로콜리 감자 고구마 옥수수
    ].sample
  end

  def noun2
    %w[마스터 헌터 러버 킬러 장인 왕 요정 대장 박사 귀신].sample
  end

  def verb
    %w[먹는 굽는 볶는 튀기는 사랑하는 찾는 모으는 키우는 그리는 노래하는].sample
  end

  def adverb
    %w[열심히 몰래 급하게 천천히 맛있게 신나게 졸리게 행복하게 용감하게 열정적으로].sample
  end

  def suffix
    %w[장인 마스터 헌터 러버 왕 대장 요정 박사 덕후 매니아].sample
  end

  def time
    %w[새벽 아침 점심 저녁 밤 월요일 금요일 주말 휴일 퇴근후].sample
  end

  def number
    rand(1..12)
  end

  def place
    %w[우주 바다 하늘 숲속 동네 골목 지하 옥상 비밀 전설의].sample
  end

  def role
    %w[배달부 사냥꾼 연구원 탐험가 수호자 감별사 소믈리에 평론가 챔피언 전도사].sample
  end
end
