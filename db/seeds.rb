# 현실적인 뷰 데이터 (제목과 선택지가 매칭됨)
VIEWS_DATA = [
  # 음식
  { title: "짜장면 vs 짬뽕", options: ["짜장면", "짬뽕"] },
  { title: "탕수육 부먹 vs 찍먹", options: ["부먹", "찍먹", "반반"] },
  { title: "최고의 치킨은?", options: ["후라이드", "양념", "간장", "마늘"] },
  { title: "피자 vs 치킨", options: ["피자", "치킨"] },
  { title: "삼겹살 vs 목살", options: ["삼겹살", "목살", "갈비", "항정살"] },
  { title: "라면 먹을 때 밥?", options: ["밥 필수", "면만", "상황따라"] },
  { title: "떡볶이 vs 순대", options: ["떡볶이", "순대", "둘 다", "모둠"] },
  { title: "마라탕 vs 마라샹궈", options: ["마라탕", "마라샹궈"] },
  { title: "초밥 vs 회", options: ["초밥", "회", "둘 다"] },
  { title: "아메리카노 vs 라떼", options: ["아메리카노", "라떼", "다른 음료"] },

  # 음료/술
  { title: "커피 vs 차", options: ["커피", "차", "안 마심"] },
  { title: "맥주 vs 소주", options: ["맥주", "소주", "둘 다", "안 마심"] },
  { title: "카페인 음료 vs 디카페인", options: ["카페인", "디카페인", "상관없음"] },

  # IT/기기
  { title: "아이폰 vs 갤럭시", options: ["아이폰", "갤럭시"] },
  { title: "맥북 vs 윈도우 노트북", options: ["맥북", "윈도우", "둘 다 사용"] },
  { title: "에어팟 vs 버즈", options: ["에어팟", "버즈", "다른 이어폰"] },
  { title: "PS5 vs 닌텐도 스위치", options: ["PS5", "스위치", "Xbox", "PC"] },
  { title: "넷플릭스 vs 티빙", options: ["넷플릭스", "티빙", "웨이브", "쿠팡플레이"] },
  { title: "유튜브 프리미엄 쓰시나요?", options: ["네", "아니오", "고민 중"] },

  # 라이프스타일
  { title: "아침형 인간 vs 저녁형 인간", options: ["아침형", "저녁형"] },
  { title: "재택근무 vs 출근", options: ["재택근무", "출근", "하이브리드"] },
  { title: "혼밥 vs 같이 먹기", options: ["혼밥 좋아", "같이 먹어야지", "상관없음"] },
  { title: "계획형 vs 즉흥형", options: ["계획형", "즉흥형", "반반"] },
  { title: "현금 vs 카드", options: ["현금", "카드", "모바일페이"] },
  { title: "새벽 배송 vs 직접 구매", options: ["새벽 배송", "마트 직접", "상관없음"] },

  # 동물
  { title: "강아지 vs 고양이", options: ["강아지", "고양이", "둘 다", "없음"] },
  { title: "반려동물 키우시나요?", options: ["네", "아니오", "키우고 싶어요"] },

  # 계절/날씨
  { title: "겨울 vs 여름", options: ["겨울", "여름", "봄", "가을"] },
  { title: "비 오는 날 vs 맑은 날", options: ["비 오는 날", "맑은 날", "흐린 날"] },

  # 여행
  { title: "여름 휴가지 추천", options: ["제주도", "부산", "강릉", "해외"] },
  { title: "여행 스타일", options: ["계획형", "즉흥형"] },
  { title: "국내 여행 vs 해외 여행", options: ["국내", "해외", "둘 다"] },
  { title: "호텔 vs 에어비앤비", options: ["호텔", "에어비앤비", "펜션", "게스트하우스"] },

  # 운동/건강
  { title: "운동 뭐 해?", options: ["헬스", "러닝", "수영", "홈트", "안 함"] },
  { title: "아침 운동 vs 저녁 운동", options: ["아침", "저녁", "점심", "상관없음"] },
  { title: "헬스장 vs 홈트", options: ["헬스장", "홈트", "둘 다"] },

  # 엔터테인먼트
  { title: "영화관 vs 집에서 영화", options: ["영화관", "집", "상관없음"] },
  { title: "드라마 vs 영화", options: ["드라마", "영화", "둘 다"] },
  { title: "책 vs 유튜브", options: ["책", "유튜브", "팟캐스트", "둘 다"] },

  # 일/직장
  { title: "회식 찬성 vs 반대", options: ["찬성", "반대", "가끔은 OK"] },
  { title: "점심 혼밥 vs 동료랑", options: ["혼밥", "동료랑", "상황따라"] },
  { title: "칼퇴 vs 야근", options: ["칼퇴 필수", "필요하면 야근", "야근 많음"] },

  # 쇼핑/브랜드
  { title: "운동화 브랜드 추천", options: ["나이키", "아디다스", "뉴발란스", "아식스"] },
  { title: "카페 어디 가세요?", options: ["스타벅스", "투썸", "이디야", "개인카페"] },
  { title: "배달앱 뭐 써요?", options: ["배민", "쿠팡이츠", "요기요"] },

  # 금융
  { title: "저축 vs 투자", options: ["저축", "투자", "반반"] },
  { title: "주거래 은행", options: ["카카오뱅크", "토스뱅크", "시중은행"] },

  # 소셜/SNS
  { title: "인스타 vs 트위터(X)", options: ["인스타그램", "트위터", "틱톡", "안 함"] },
  { title: "카톡 vs 문자", options: ["카톡", "문자", "전화"] },

  # 기타
  { title: "아침에 일어나면 제일 먼저?", options: ["핸드폰 확인", "화장실", "물 마시기", "알람 끄기"] },
  { title: "주말에 뭐해?", options: ["집에서 휴식", "밖에서 놀기", "운동", "공부/자기계발"] },
  { title: "결혼식 축의금 얼마?", options: ["3만원", "5만원", "10만원", "관계에 따라"] },
  { title: "택시 vs 대중교통", options: ["택시", "대중교통", "자차", "킥보드"] },
]

# 주제별 추가 데이터
TOPIC_QUESTIONS = {
  "노트북" => { q: ["뭐 쓰세요?", "추천해주세요", "어떤 게 좋아요?"], opts: ["맥북", "삼성", "LG그램", "레노버"] },
  "이어폰" => { q: ["뭐 쓰세요?", "추천해주세요"], opts: ["에어팟", "버즈", "소니", "젠하이저"] },
  "모니터" => { q: ["몇 인치 쓰세요?", "추천해주세요"], opts: ["24인치", "27인치", "32인치 이상", "듀얼"] },
  "키보드" => { q: ["기계식 vs 멤브레인", "뭐 쓰세요?"], opts: ["기계식", "멤브레인", "무접점", "애플"] },
  "마우스" => { q: ["유선 vs 무선", "추천해주세요"], opts: ["유선", "무선", "버티컬", "트랙패드"] },
  "의자" => { q: ["추천해주세요", "얼마짜리 쓰세요?"], opts: ["허먼밀러", "시디즈", "듀오백", "가성비"] },
  "자동차" => { q: ["뭐 타세요?", "추천해주세요"], opts: ["현대", "기아", "테슬라", "외제차"] },
  "자전거" => { q: ["타시나요?", "어떤 종류?"], opts: ["로드", "MTB", "하이브리드", "따릉이"] },
}

puts "뷰 데이터 생성 시작..."

# 유저 확인
user = User.first
unless user
  puts "유저가 없습니다. 먼저 유저를 생성해주세요."
  exit
end

# 기본 데이터 생성
VIEWS_DATA.each do |data|
  View.create!(
    user_id: user.id,
    title: data[:title],
    votes_count: rand(0..500),
    view_options_attributes: data[:options].map { |opt| { content: opt } }
  )
end
puts "기본 데이터 #{VIEWS_DATA.size}개 생성 완료"

# 주제별 추가 생성
count = 0
TOPIC_QUESTIONS.each do |topic, data|
  data[:q].each do |question|
    View.create!(
      user_id: user.id,
      title: "#{topic} #{question}",
      votes_count: rand(0..300),
      view_options_attributes: data[:opts].map { |opt| { content: opt } }
    )
    count += 1
  end
end
puts "주제별 데이터 #{count}개 생성 완료"

# 같은 제목+선택지로 더 많은 데이터 생성
remaining = [1000 - View.count, 0].max
puts "#{remaining}개 추가 생성 중..."

remaining.times do |i|
  base = VIEWS_DATA.sample
  View.create!(
    user_id: user.id,
    title: "#{base[:title]} ##{i + 1}",
    votes_count: rand(0..200),
    view_options_attributes: base[:options].map { |opt| { content: opt } }
  )
  print '.' if (i + 1) % 100 == 0
end

puts
puts "완료! 총 뷰 개수: #{View.count}"
