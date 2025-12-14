# 운영용 뷰 데이터 100개
PRODUCTION_VIEWS = [
  # 음식/맛집 (15개)
  { title: "짜장면 vs 짬뽕", options: [ "짜장면", "짬뽕", "짬짜면" ] },
  { title: "탕수육 부먹 vs 찍먹", options: [ "부먹", "찍먹", "반반" ] },
  { title: "최고의 치킨 메뉴는?", options: [ "후라이드", "양념", "간장", "마늘", "반반" ] },
  { title: "라면에 밥 말아먹기", options: [ "당연히 한다", "절대 안한다", "가끔" ] },
  { title: "삼겹살 vs 목살 vs 항정살", options: [ "삼겹살", "목살", "항정살", "갈비" ] },
  { title: "떡볶이 맵기는?", options: [ "순한맛", "중간맛", "매운맛", "불닭맛" ] },
  { title: "초밥 vs 회", options: [ "초밥", "회", "둘 다 좋아" ] },
  { title: "아침 메뉴 추천", options: [ "토스트", "김밥", "죽", "샌드위치", "굶는다" ] },
  { title: "커피는 어떻게?", options: [ "아메리카노", "라떼", "바닐라라떼", "안 마심" ] },
  { title: "여름 디저트 최애는?", options: [ "빙수", "아이스크림", "아이스커피", "빙과류" ] },
  { title: "야식 메뉴 BEST", options: [ "치킨", "피자", "족발", "라면", "떡볶이" ] },
  { title: "햄버거 프랜차이즈 픽", options: [ "맥도날드", "버거킹", "롯데리아", "맘스터치", "KFC" ] },
  { title: "편의점 도시락 추천", options: [ "컵밥", "삼각김밥", "샌드위치", "도시락", "안 먹음" ] },
  { title: "소주는 어떤 걸로?", options: [ "참이슬", "처음처럼", "좋은데이", "안 마심" ] },
  { title: "맥주 vs 소주", options: [ "맥주", "소주", "폭탄주", "안 마심" ] },

  # IT/기술/디지털 (15개)
  { title: "아이폰 vs 갤럭시", options: [ "아이폰", "갤럭시" ] },
  { title: "맥북 vs 윈도우 노트북", options: [ "맥북", "윈도우", "둘 다 사용" ] },
  { title: "에어팟 vs 버즈", options: [ "에어팟", "버즈", "다른 브랜드" ] },
  { title: "넷플릭스 vs 티빙 vs 웨이브", options: [ "넷플릭스", "티빙", "웨이브", "쿠팡플레이", "디즈니+" ] },
  { title: "유튜브 프리미엄 쓰시나요?", options: [ "쓴다", "안 쓴다", "고민 중" ] },
  { title: "게임 플랫폼은?", options: [ "PS5", "닌텐도 스위치", "Xbox", "PC", "모바일만" ] },
  { title: "노트북 구매 예산은?", options: [ "100만원 이하", "100-200만원", "200-300만원", "300만원 이상" ] },
  { title: "모니터 몇 개 쓰세요?", options: [ "1대", "2대(듀얼)", "3대 이상" ] },
  { title: "키보드 취향은?", options: [ "기계식", "멤브레인", "무접점", "매직키보드" ] },
  { title: "마우스 vs 트랙패드", options: [ "마우스", "트랙패드", "둘 다" ] },
  { title: "클라우드 스토리지 뭐 쓰세요?", options: [ "구글 드라이브", "아이클라우드", "네이버 마이박스", "드롭박스", "안 씀" ] },
  { title: "스마트워치 쓰시나요?", options: [ "애플워치", "갤럭시워치", "다른 브랜드", "안 씀" ] },
  { title: "태블릿 필요하신가요?", options: [ "필수", "있으면 좋음", "필요 없음" ] },
  { title: "크롬 vs 사파리 vs 엣지", options: [ "크롬", "사파리", "엣지", "파이어폭스" ] },
  { title: "AI 챗봇 뭐 쓰세요?", options: [ "ChatGPT", "Claude", "Gemini", "안 씀" ] },

  # 라이프스타일 (15개)
  { title: "아침형 vs 저녁형 인간", options: [ "아침형", "저녁형" ] },
  { title: "재택근무 vs 출근", options: [ "재택", "출근", "하이브리드" ] },
  { title: "혼밥 괜찮으신가요?", options: [ "좋아함", "싫어함", "상관없음" ] },
  { title: "계획형 vs 즉흥형", options: [ "계획형", "즉흥형", "반반" ] },
  { title: "현금 vs 카드", options: [ "현금", "카드", "모바일페이" ] },
  { title: "새벽 배송 자주 이용하시나요?", options: [ "자주", "가끔", "안 함" ] },
  { title: "반려동물 키우시나요?", options: [ "강아지", "고양이", "둘 다", "안 키움" ] },
  { title: "좋아하는 계절은?", options: [ "봄", "여름", "가을", "겨울" ] },
  { title: "주말 보내는 방법", options: [ "집에서 쉼", "외출", "운동", "자기계발" ] },
  { title: "알람 몇 개 맞춰놓으세요?", options: [ "1개", "2-3개", "4-5개", "6개 이상" ] },
  { title: "샤워는 언제?", options: [ "아침", "저녁", "양쪽 다", "격일" ] },
  { title: "이불 vs 침대", options: [ "이불 (바닥)", "침대", "둘 다" ] },
  { title: "집 청소 얼마나 자주?", options: [ "매일", "주 2-3회", "주 1회", "한 달에 한 번" ] },
  { title: "빨래 모아서 vs 바로바로", options: [ "모아서", "바로바로" ] },
  { title: "분리수거 잘하시나요?", options: [ "철저히", "대충", "가끔 헷갈림" ] },

  # 여행/레저 (10개)
  { title: "여름 휴가지 추천", options: [ "제주도", "부산", "강릉", "해외" ] },
  { title: "여행 스타일", options: [ "계획형", "즉흥형" ] },
  { title: "국내 vs 해외 여행", options: [ "국내", "해외", "둘 다" ] },
  { title: "숙소는 어디로?", options: [ "호텔", "에어비앤비", "펜션", "게스트하우스" ] },
  { title: "패키지 vs 자유여행", options: [ "패키지", "자유여행", "반반" ] },
  { title: "여행 사진 많이 찍으시나요?", options: [ "엄청 많이", "적당히", "거의 안 찍음" ] },
  { title: "비행기 좌석 선호도", options: [ "창가", "복도", "상관없음" ] },
  { title: "캠핑 vs 호캉스", options: [ "캠핑", "호캉스", "둘 다" ] },
  { title: "산 vs 바다", options: [ "산", "바다", "둘 다" ] },
  { title: "테마파크 좋아하시나요?", options: [ "좋아함", "보통", "싫어함" ] },

  # 쇼핑/패션 (10개)
  { title: "운동화 브랜드 픽", options: [ "나이키", "아디다스", "뉴발란스", "아식스", "컨버스" ] },
  { title: "청바지 핏은?", options: [ "스키니", "슬림", "스트레이트", "와이드" ] },
  { title: "옷 쇼핑 어디서?", options: [ "온라인", "오프라인", "둘 다" ] },
  { title: "패딩 브랜드 추천", options: [ "노스페이스", "디스커버리", "네파", "유니클로", "기타" ] },
  { title: "가방 선호도", options: [ "백팩", "크로스백", "토트백", "안 들고 다님" ] },
  { title: "신발 몇 켤레 가지고 계세요?", options: [ "3켤레 이하", "4-6켤레", "7-10켤레", "10켤레 이상" ] },
  { title: "명품 관심 있으세요?", options: [ "관심 많음", "보통", "관심 없음" ] },
  { title: "배달앱 주로 어디?", options: [ "배민", "쿠팡이츠", "요기요" ] },
  { title: "택배 얼마나 자주 받으시나요?", options: [ "주 5회 이상", "주 2-4회", "주 1회", "한 달에 몇 번" ] },
  { title: "중고거래 하시나요?", options: [ "자주", "가끔", "안 함" ] },

  # 엔터테인먼트 (10개)
  { title: "영화관 vs 집관", options: [ "영화관", "집", "둘 다" ] },
  { title: "드라마 vs 영화", options: [ "드라마", "영화", "둘 다" ] },
  { title: "책 vs 유튜브", options: [ "책", "유튜브", "둘 다" ] },
  { title: "좋아하는 영화 장르", options: [ "액션", "로맨스", "코미디", "스릴러", "SF", "공포" ] },
  { title: "음악 스트리밍 서비스", options: [ "멜론", "지니", "플로", "스포티파이", "유튜브뮤직" ] },
  { title: "노래방 좋아하세요?", options: [ "좋아함", "보통", "싫어함" ] },
  { title: "콘서트 자주 가시나요?", options: [ "자주", "가끔", "거의 안 감" ] },
  { title: "게임 장르 선호도", options: [ "RPG", "FPS", "AOS/MOBA", "캐주얼", "안 함" ] },
  { title: "웹툰 vs 웹소설", options: [ "웹툰", "웹소설", "둘 다", "안 봄" ] },
  { title: "팟캐스트 들으세요?", options: [ "자주", "가끔", "안 들음" ] },

  # 직장/커리어 (10개)
  { title: "회식 어떻게 생각하세요?", options: [ "좋다", "싫다", "가끔은 OK" ] },
  { title: "점심 혼밥 vs 동료랑", options: [ "혼밥", "동료랑", "상황따라" ] },
  { title: "칼퇴 vs 야근", options: [ "칼퇴 필수", "필요하면 야근", "야근 많음" ] },
  { title: "연차 잘 쓰시나요?", options: [ "자주", "가끔", "잘 안 씀" ] },
  { title: "커피챗 어떻게 생각하세요?", options: [ "좋다", "부담스럽다", "상관없음" ] },
  { title: "이직 주기는?", options: [ "1년", "2-3년", "4-5년", "장기근속" ] },
  { title: "대기업 vs 스타트업", options: [ "대기업", "스타트업", "상관없음" ] },
  { title: "직장 선택 기준 1순위", options: [ "연봉", "워라밸", "커리어", "복지", "위치" ] },
  { title: "점심시간 몇 분?", options: [ "30분", "1시간", "1시간 30분", "2시간" ] },
  { title: "업무 소통 도구", options: [ "슬랙", "잔디", "카톡", "이메일", "MS팀즈" ] },

  # 건강/운동 (5개)
  { title: "운동 어떻게 하세요?", options: [ "헬스", "러닝", "수영", "홈트", "요가/필라테스", "안 함" ] },
  { title: "운동 시간대는?", options: [ "아침", "점심", "저녁", "심야" ] },
  { title: "헬스장 vs 홈트", options: [ "헬스장", "홈트", "둘 다" ] },
  { title: "건강검진 정기적으로 받으시나요?", options: [ "매년", "2-3년에 한 번", "안 받음" ] },
  { title: "비타민 챙겨드시나요?", options: [ "매일", "가끔", "안 먹음" ] },

  # 금융/재테크 (5개)
  { title: "저축 vs 투자", options: [ "저축", "투자", "반반" ] },
  { title: "주거래 은행", options: [ "카카오뱅크", "토스뱅크", "시중은행" ] },
  { title: "주식 하시나요?", options: [ "한다", "안 한다", "관심 있음" ] },
  { title: "월급 타면 제일 먼저?", options: [ "저축", "카드값", "생활비", "투자", "쇼핑" ] },
  { title: "보험 몇 개 들어놓으셨어요?", options: [ "1-2개", "3-4개", "5개 이상", "없음" ] },

  # 기타/트렌드 (5개)
  { title: "인스타 vs 틱톡", options: [ "인스타", "틱톡", "둘 다", "안 함" ] },
  { title: "카톡 vs 문자", options: [ "카톡", "문자", "전화" ] },
  { title: "MBTI 믿으세요?", options: [ "믿는다", "안 믿는다", "재미로만" ] },
  { title: "새해 목표 세우세요?", options: [ "매년 세움", "가끔", "안 세움" ] },
  { title: "다이어리 쓰시나요?", options: [ "종이 다이어리", "디지털", "안 씀" ] }
]

puts "🌱 데이터베이스 초기화 중..."

# 기존 데이터 삭제
puts "기존 데이터 삭제 중..."
Comment.destroy_all
Vote.destroy_all
ViewOption.destroy_all
View.destroy_all
User.destroy_all

puts "✅ 기존 데이터 삭제 완료"

# 테스트 유저 생성
puts "\n👤 테스트 유저 생성 중..."
users = []

# 메인 유저
main_user = User.create!(
  email: "test@example.com",
  nickname: "뷰마스터",
  provider: "kakao",
  uid: "test_uid_1"
)
users << main_user
puts "  - #{main_user.nickname} 생성"

# 추가 유저들 (댓글/투표용)
30.times do |i|
  user = User.create!(
    email: "user#{i + 1}@example.com",
    nickname: "유저#{i + 1}",
    provider: "kakao",
    uid: "test_uid_#{i + 2}"
  )
  users << user
  print "  - #{user.nickname} 생성\n" if (i + 1) % 10 == 0
end

puts "✅ 총 #{users.count}명의 유저 생성 완료\n"

# 뷰 생성
puts "📊 뷰 데이터 생성 중..."
created_views = []

PRODUCTION_VIEWS.each_with_index do |data, index|
  # 다양한 유저가 작성한 것처럼
  author = users.sample

  view = View.create!(
    user: author,
    title: data[:title],
    view_options_attributes: data[:options].map { |opt| { content: opt } }
  )
  created_views << view

  print "." if (index + 1) % 10 == 0
end

puts "\n✅ #{created_views.count}개 뷰 생성 완료\n"

# 투표 데이터 추가 (자연스러운 분포)
puts "🗳️  투표 데이터 생성 중..."
vote_count = 0

created_views.each do |view|
  # 뷰마다 랜덤하게 10-50명이 투표 (더 활발한 느낌)
  voters = users.sample(rand(10..50))

  voters.each do |voter|
    option = view.view_options.sample
    begin
      Vote.create!(
        user: voter,
        view_option: option
      )
      vote_count += 1
    rescue ActiveRecord::RecordInvalid
      # 중복 투표는 스킵
    end
  end
end

puts "✅ #{vote_count}개 투표 생성 완료\n"

# 댓글 데이터 추가
puts "💬 댓글 데이터 생성 중..."

comment_templates = [
  "좋은 질문이네요!",
  "저는 {option} 선택했어요",
  "이거 진짜 고민되는 주제네요 ㅋㅋ",
  "완전 공감합니다",
  "{option} 강추!",
  "저만 {option}인가요?",
  "이거 TMI인데 저는 {option}",
  "예전에는 {option}이었는데 요즘은 다른 것도 괜찮더라구요",
  "무조건 {option}이죠",
  "신기하게 주변에선 다들 {option}",
  "계속 고민하다가 {option}로 정착했어요",
  "개인적으로 {option} 추천드립니다!",
  "{option} 써보니까 생각보다 좋더라구요",
  "저도 이거 궁금했는데 역시 다들 {option}",
  "의외네요! 전 당연히 {option}인 줄",
  "와 신기하다 저랑 정반대시네요 ㅎㅎ",
  "이건 호불호가 갈리는 것 같아요",
  "상황에 따라 다른 것 같은데요?",
  "이거 세대차이 있을 것 같아요",
  "지역마다 다를 것 같기도 하고..."
]

comment_count = 0
created_views.each do |view|
  # 각 뷰마다 1-12개의 댓글
  rand(1..12).times do
    commenter = users.sample
    option = view.view_options.sample

    template = comment_templates.sample
    content = template.gsub("{option}", option.content)

    Comment.create!(
      user: commenter,
      view: view,
      content: content
    )
    comment_count += 1
  end
end

puts "✅ #{comment_count}개 댓글 생성 완료\n"

# 최종 통계
puts "\n" + "=" * 50
puts "🎉 데이터 생성 완료!"
puts "=" * 50
puts "📊 최종 통계:"
puts "  - 유저: #{User.count}명"
puts "  - 뷰: #{View.count}개"
puts "  - 선택지: #{ViewOption.count}개"
puts "  - 투표: #{Vote.count}개"
puts "  - 댓글: #{Comment.count}개"
puts "=" * 50
puts "\n💡 테스트 계정:"
puts "  이메일: test@example.com"
puts "  닉네임: 뷰마스터"
puts "\n✨ seeds.rb 실행 완료!"
