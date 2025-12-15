# frozen_string_literal: true

class NicknameGenerator
  MAX_ATTEMPTS = 10

  ADJECTIVES = %w[
    행복한 즐거운 신나는 멋진 귀여운 용감한 지혜로운 활발한 상냥한 든든한
    빛나는 따뜻한 시원한 달콤한 상큼한 포근한 씩씩한 깜찍한 당당한 유쾌한
    졸린 배고픈 심심한 설레는 두근두근 반짝반짝 몽글몽글 말랑말랑 쫄깃쫄깃
  ].freeze

  NOUNS = %w[
    탕수육 치킨 피자 햄버거 떡볶이 김밥 라면 초밥 파스타 스테이크
    고양이 강아지 토끼 판다 호랑이 사자 여우 곰돌이 펭귄 코알라
    수박 망고 딸기 바나나 아보카도 당근 브로콜리 감자 고구마 옥수수
  ].freeze

  SUFFIXES = %w[마스터 헌터 러버 킬러 장인 왕 요정 대장 박사 귀신].freeze
  VERBS = %w[먹는 굽는 볶는 튀기는 사랑하는 찾는 모으는 키우는 그리는 노래하는].freeze
  ADVERBS = %w[열심히 몰래 급하게 천천히 맛있게 신나게 졸리게 행복하게 용감하게 열정적으로].freeze
  TIMES = %w[새벽 아침 점심 저녁 밤 월요일 금요일 주말 휴일 퇴근후].freeze
  PLACES = %w[우주 바다 하늘 숲속 동네 골목 지하 옥상 비밀 전설의].freeze
  ROLES = %w[배달부 사냥꾼 연구원 탐험가 수호자 감별사 소믈리에 평론가 챔피언 전도사].freeze

  PATTERNS = [
    ->(g) { "#{g.adjective} #{g.noun}" },
    ->(g) { "#{g.noun} #{g.verb} #{g.suffix}" },
    ->(g) { "#{g.adverb} #{g.verb} #{g.noun}" },
    ->(g) { "#{g.noun}#{g.suffix}" },
    ->(g) { "#{g.time} #{g.number}시 #{g.noun}" },
    ->(g) { "#{g.place} #{g.noun} #{g.role}" }
  ].freeze

  def self.generate
    new.generate
  end

  def generate
    attempt = 0

    loop do
      attempt += 1
      nickname = build_nickname(attempt > 5)

      return nickname unless User.exists?(nickname: nickname)

      # 최대 시도 횟수 초과 시 랜덤 문자열 추가하여 강제 유니크
      return "#{build_nickname(false)}_#{SecureRandom.hex(4)}" if attempt >= MAX_ATTEMPTS
    end
  end

  def adjective
    ADJECTIVES.sample
  end

  def noun
    NOUNS.sample
  end

  def suffix
    SUFFIXES.sample
  end

  def verb
    VERBS.sample
  end

  def adverb
    ADVERBS.sample
  end

  def time
    TIMES.sample
  end

  def number
    rand(1..12)
  end

  def place
    PLACES.sample
  end

  def role
    ROLES.sample
  end

  private

  def build_nickname(with_suffix = false)
    base = PATTERNS.sample.call(self)
    with_suffix ? "#{base}#{rand(1000..9999)}" : base
  end
end
