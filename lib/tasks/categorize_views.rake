# frozen_string_literal: true

namespace :views do
  desc "기존 뷰 데이터를 제목 키워드 기반으로 카테고리 분류"
  task categorize: :environment do
    # 키워드 매핑 (우선순위 순서)
    CATEGORY_KEYWORDS = {
      food: %w[
        음식 맛집 먹 치킨 피자 햄버거 라면 밥 커피 술 소주 맥주 와인
        짜장 짬뽕 초밥 회 고기 삼겹 목살 떡볶이 분식 디저트 빵 케이크
        아이스크림 빙수 카페 식당 배달 야식 아침 점심 저녁 브런치
      ],
      travel: %w[
        여행 휴가 여름 겨울 제주 부산 강릉 해외 국내 비행기 호텔
        숙소 에어비앤비 펜션 캠핑 호캉스 바다 산 테마파크 놀이공원
      ],
      work: %w[
        직장 회사 출근 퇴근 야근 칼퇴 연차 휴가 회식 점심 동료
        상사 이직 취업 커리어 연봉 워라밸 재택 사무실 업무 슬랙
      ],
      game: %w[
        게임 롤 발로 오버워치 스팀 플스 PS5 닌텐도 스위치 Xbox PC게임
        모바일게임 RPG FPS 배그 LOL e스포츠
      ],
      hobby: %w[
        취미 운동 헬스 러닝 수영 요가 필라테스 등산 자전거
        영화 드라마 넷플릭스 티빙 웨이브 디즈니 음악 노래방 콘서트
        책 독서 웹툰 웹소설 유튜브 팟캐스트
      ],
      fashion: %w[
        옷 패션 스타일 브랜드 신발 운동화 가방 명품 쇼핑
        청바지 패딩 코트 자켓 원피스 티셔츠
      ],
      relationship: %w[
        연애 사랑 썸 고백 데이트 남친 여친 결혼 이별
        짝사랑 소개팅 만남 커플
      ],
      stock: %w[
        주식 코인 비트코인 이더리움 투자 펀드 ETF 배당 증권 삼성전자
        테슬라 애플 나스닥 코스피 코스닥 매수 매도 차트 급등 급락
        가상화폐 암호화폐 부동산 재테크 금리 환율
      ],
      adult: %w[
        19금 성인 야한 섹스 술집 클럽 나이트 헌팅 원나잇
      ],
      etc: %w[
        MBTI 인스타 틱톡 SNS 트렌드
      ]
    }.freeze

    def categorize_by_title(title)
      title_lower = title.downcase

      CATEGORY_KEYWORDS.each do |category, keywords|
        keywords.each do |keyword|
          return category if title_lower.include?(keyword.downcase)
        end
      end

      :daily # 기본값
    end

    puts "🏷️  뷰 카테고리 자동 분류 시작..."
    puts "=" * 50

    # 통계 초기화
    stats = Hash.new(0)
    updated_count = 0

    # daily 카테고리인 뷰만 대상 (이미 분류된 것은 제외)
    views_to_categorize = View.where(category: :daily)
    total = views_to_categorize.count

    puts "분류 대상: #{total}개 뷰 (현재 daily 카테고리)"
    puts ""

    views_to_categorize.find_each.with_index do |view, index|
      new_category = categorize_by_title(view.title)

      if new_category != :daily
        view.update_column(:category, View.categories[new_category])
        updated_count += 1
      end

      stats[new_category] += 1

      # 진행률 표시
      print "\r진행 중: #{index + 1}/#{total} (#{((index + 1).to_f / total * 100).round(1)}%)"
    end

    puts "\n\n"
    puts "=" * 50
    puts "✅ 분류 완료!"
    puts "=" * 50
    puts "\n📊 카테고리별 분류 결과:"

    View.categories.keys.each do |cat|
      count = View.where(category: cat).count
      puts "  - #{cat}: #{count}개"
    end

    puts "\n총 #{updated_count}개 뷰의 카테고리가 변경되었습니다."
    puts "=" * 50
  end

  desc "카테고리 분류 시뮬레이션 (실제 변경 없음)"
  task categorize_dry_run: :environment do
    CATEGORY_KEYWORDS = {
      food: %w[음식 맛집 먹 치킨 피자 햄버거 라면 밥 커피 술 소주 맥주],
      travel: %w[여행 휴가 제주 부산 강릉 해외 비행기 호텔 캠핑],
      work: %w[직장 회사 출근 퇴근 야근 연차 회식 이직 연봉],
      game: %w[게임 롤 플스 닌텐도 스위치 RPG FPS],
      hobby: %w[취미 운동 헬스 영화 드라마 넷플릭스 음악 책],
      fashion: %w[옷 패션 신발 가방 명품 쇼핑],
      relationship: %w[연애 사랑 썸 데이트 결혼],
      stock: %w[주식 코인 비트코인 투자 ETF 배당 증권 재테크],
      adult: %w[19금 성인 야한 술집 클럽],
      etc: %w[MBTI 인스타 틱톡]
    }.freeze

    def categorize_by_title(title)
      title_lower = title.downcase
      CATEGORY_KEYWORDS.each do |category, keywords|
        keywords.each do |keyword|
          return category if title_lower.include?(keyword.downcase)
        end
      end
      :daily
    end

    puts "🔍 분류 시뮬레이션 (Dry Run)"
    puts "=" * 50

    stats = Hash.new(0)
    examples = Hash.new { |h, k| h[k] = [] }

    View.where(category: :daily).find_each do |view|
      new_category = categorize_by_title(view.title)
      stats[new_category] += 1

      # 각 카테고리별 예시 3개씩 저장
      if examples[new_category].size < 3
        examples[new_category] << view.title
      end
    end

    puts "\n📊 예상 분류 결과:\n"
    stats.sort_by { |_, v| -v }.each do |category, count|
      puts "#{category}: #{count}개"
      examples[category].each { |title| puts "  - #{title}" }
      puts ""
    end
  end
end
