# 인증 시스템

## 개요

카카오 OAuth2를 통한 소셜 로그인과 JWT 기반 API 인증을 사용합니다.

## 인증 흐름

```
┌──────────┐     ┌──────────┐     ┌──────────┐     ┌──────────┐
│ Frontend │     │ View API │     │  Kakao   │     │ Frontend │
└────┬─────┘     └────┬─────┘     └────┬─────┘     └────┬─────┘
     │                │                │                │
     │ 1. 로그인 클릭  │                │                │
     │───────────────>│                │                │
     │                │                │                │
     │ 2. 카카오 인증 페이지로 리다이렉트     │                │
     │<───────────────│                │                │
     │                │                │                │
     │ 3. 카카오 로그인 페이지            │                │
     │────────────────────────────────>│                │
     │                │                │                │
     │ 4. 로그인 완료, callback으로 리다이렉트             │
     │<────────────────────────────────│                │
     │                │                │                │
     │ 5. callback 요청 (code 포함)     │                │
     │───────────────>│                │                │
     │                │                │                │
     │                │ 6. code로 access_token 교환      │
     │                │───────────────>│                │
     │                │                │                │
     │                │ 7. 사용자 정보 요청               │
     │                │───────────────>│                │
     │                │                │                │
     │                │ 8. 사용자 정보 반환               │
     │                │<───────────────│                │
     │                │                │                │
     │ 9. JWT 토큰과 함께 프론트엔드로 리다이렉트           │
     │<───────────────│                │                │
     │                │                │                │
     │ 10. JWT 저장 후 API 요청 시 사용                  │
     │────────────────────────────────────────────────>│
```

## API 엔드포인트

### 1. 카카오 로그인 시작

```
GET /auth/kakao
```

카카오 로그인 페이지로 리다이렉트됩니다.

### 2. 카카오 콜백 (내부 처리)

```
GET /auth/kakao/callback
```

카카오 로그인 성공 후 자동으로 호출됩니다.

**성공 시:** `FRONTEND_URL/auth/callback?token={JWT_TOKEN}`으로 리다이렉트

**실패 시:** `FRONTEND_URL/auth/failure?message=login_failed`로 리다이렉트

### 3. 현재 사용자 정보 조회

```
GET /auth/me
```

**Headers:**
```
Authorization: Bearer {JWT_TOKEN}
```

**Response (200 OK):**
```json
{
  "id": 1,
  "email": "user@example.com",
  "name": "홍길동",
  "profile_image": "https://..."
}
```

**Response (401 Unauthorized):**
```json
{
  "error": "Unauthorized"
}
```

## 설정

### 환경 변수

| 변수명 | 설명 | 기본값 |
|--------|------|--------|
| `FRONTEND_URL` | 프론트엔드 URL | `http://localhost:3001` |

### Credentials 설정

```bash
rails credentials:edit
```

```yaml
kakao:
  client_id: YOUR_KAKAO_REST_API_KEY
  client_secret: YOUR_KAKAO_CLIENT_SECRET
```

### 카카오 개발자 콘솔 설정

1. [Kakao Developers](https://developers.kakao.com) 접속
2. 애플리케이션 생성
3. **카카오 로그인** 활성화
4. **Redirect URI** 등록:
   - 개발: `http://localhost:3000/auth/kakao/callback`
   - 운영: `https://your-api-domain.com/auth/kakao/callback`

## 주요 파일

| 파일 | 설명 |
|------|------|
| `app/controllers/auth_controller.rb` | 인증 관련 컨트롤러 |
| `app/models/user.rb` | 사용자 모델, OAuth 데이터 처리 |
| `app/services/jwt_service.rb` | JWT 토큰 생성/검증 |
| `config/initializers/omniauth.rb` | OmniAuth 카카오 설정 |

## JWT 토큰

- **만료 시간:** 24시간
- **Payload:** `{ user_id: 1, exp: 1234567890 }`
- **서명 키:** `Rails.application.credentials.secret_key_base`

## 프론트엔드 연동 예시

```javascript
// 1. 로그인 버튼 클릭 시
window.location.href = 'http://localhost:3000/auth/kakao';

// 2. 콜백 페이지에서 토큰 저장
const params = new URLSearchParams(window.location.search);
const token = params.get('token');
localStorage.setItem('token', token);

// 3. API 요청 시 토큰 사용
fetch('http://localhost:3000/auth/me', {
  headers: {
    'Authorization': `Bearer ${localStorage.getItem('token')}`
  }
});
```
