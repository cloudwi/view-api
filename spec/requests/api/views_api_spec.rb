# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Views API", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:headers) { auth_headers(user) }

  describe "GET /views" do
    before do
      create_list(:view, 5, user: user)
      create_list(:view, 3, :food, user: other_user)
    end

    context "인증 없이" do
      it "뷰 목록을 반환한다" do
        get "/views"

        expect(response).to have_http_status(:ok)
        expect(json_response[:data].size).to eq(8)
        expect(json_response[:meta]).to include(:per_page, :has_next)
      end
    end

    context "페이지네이션" do
      before { create_list(:view, 20, user: user) }

      it "기본 per_page는 20이다" do
        get "/views"

        expect(json_response[:data].size).to eq(20)
        expect(json_response[:meta][:has_next]).to be true
      end

      it "cursor를 사용하여 다음 페이지를 조회한다" do
        get "/views"
        next_cursor = json_response[:meta][:next_cursor]

        get "/views", params: { cursor: next_cursor }

        expect(response).to have_http_status(:ok)
        expect(json_response[:data].size).to be > 0
      end

      it "per_page를 조정할 수 있다" do
        get "/views", params: { per_page: 5 }

        expect(json_response[:data].size).to eq(5)
      end

      it "per_page 최대값은 100이다" do
        get "/views", params: { per_page: 200 }

        expect(json_response[:data].size).to be <= 100
      end
    end

    context "검색" do
      before do
        create(:view, title: "점심 메뉴 추천", user: user)
        create(:view, title: "저녁 메뉴 고민", user: user)
      end

      it "제목으로 검색한다" do
        get "/views", params: { q: "메뉴" }

        expect(json_response[:data].size).to eq(2)
      end

      it "검색 결과가 없으면 빈 배열을 반환한다" do
        get "/views", params: { q: "없는키워드" }

        expect(json_response[:data]).to be_empty
      end

      it "검색어가 너무 길면 에러를 반환한다" do
        get "/views", params: { q: "a" * 101 }

        expect(response).to have_http_status(:bad_request)
        expect(json_response[:error][:code]).to eq("QUERY_TOO_LONG")
      end
    end

    context "정렬" do
      it "최신순으로 정렬한다 (기본값)" do
        get "/views", params: { sort: "latest" }

        dates = json_response[:data].map { |v| v[:created_at] }
        expect(dates).to eq(dates.sort.reverse)
      end

      it "투표 많은 순으로 정렬한다" do
        view_with_votes = create(:view, :with_votes, user: user)

        get "/views", params: { sort: "most_votes" }

        expect(json_response[:data].first[:id]).to eq(view_with_votes.id)
      end
    end

    context "카테고리 필터" do
      it "특정 카테고리만 조회한다" do
        get "/views", params: { category: "food" }

        expect(json_response[:data].size).to eq(3)
        expect(json_response[:data].map { |v| v[:category][:slug] }.uniq).to eq([ "food" ])
      end

      it "존재하지 않는 카테고리는 무시한다" do
        get "/views", params: { category: "invalid" }

        expect(json_response[:data].size).to eq(8)
      end
    end

    context "투표 필터" do
      let(:voted_view) { create(:view, user: other_user) }
      let(:not_voted_view) { create(:view, user: other_user) }

      before do
        create(:vote, user: user, view_option: voted_view.view_options.first)
      end

      it "인증 없이 투표 필터를 사용하면 에러를 반환한다" do
        get "/views", params: { vote_filter: "voted" }

        expect(response).to have_http_status(:unauthorized)
        expect(json_response[:error][:code]).to eq("LOGIN_REQUIRED")
      end

      it "투표한 뷰만 조회한다" do
        get "/views", params: { vote_filter: "voted" }, headers: headers

        expect(json_response[:data].map { |v| v[:id] }).to include(voted_view.id)
      end

      it "투표하지 않은 뷰만 조회한다" do
        get "/views", params: { vote_filter: "not_voted" }, headers: headers

        expect(json_response[:data].map { |v| v[:id] }).not_to include(voted_view.id)
      end

      it "잘못된 vote_filter 값은 에러를 반환한다" do
        get "/views", params: { vote_filter: "invalid" }, headers: headers

        expect(response).to have_http_status(:bad_request)
        expect(json_response[:error][:code]).to eq("INVALID_VOTE_FILTER")
      end
    end

    context "작성자 필터" do
      it "내가 작성한 뷰만 조회한다" do
        get "/views", params: { author: "me" }, headers: headers

        expect(json_response[:data].size).to eq(5)
        expect(json_response[:data].map { |v| v[:author][:id] }.uniq).to eq([ user.id ])
      end
    end
  end

  describe "GET /views/:id" do
    let(:view) { create(:view, :with_comments, user: user) }

    it "뷰 상세 정보를 반환한다" do
      get "/views/#{view.id}"

      expect(response).to have_http_status(:ok)
      expect(json_response[:data][:id]).to eq(view.id)
      expect(json_response[:data][:title]).to eq(view.title)
      expect(json_response[:data][:comments]).to be_an(Array)
      expect(json_response[:data][:comments].size).to eq(3)
    end

    it "존재하지 않는 뷰는 404를 반환한다" do
      get "/views/99999"

      expect(response).to have_http_status(:not_found)
      expect(json_response[:error][:code]).to eq("NOT_FOUND")
    end

    context "인증된 사용자" do
      let(:voted_view) { create(:view, user: other_user) }

      before do
        create(:vote, user: user, view_option: voted_view.view_options.first)
      end

      it "my_vote 정보를 포함한다" do
        get "/views/#{voted_view.id}", headers: headers

        expect(json_response[:data][:my_vote]).to be_present
        expect(json_response[:data][:my_vote][:option_id]).to eq(voted_view.view_options.first.id)
      end
    end
  end

  describe "POST /views" do
    let(:food_category) { create(:category, :food) }
    let(:valid_params) do
      {
        view: {
          title: "새로운 뷰 제목",
          category_id: food_category.id,
          view_options_attributes: [
            { content: "선택지 A" },
            { content: "선택지 B" }
          ]
        }
      }
    end

    context "인증된 사용자" do
      it "새 뷰를 생성한다" do
        expect {
          post "/views", params: valid_params, headers: headers
        }.to change(View, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(json_response[:data][:title]).to eq("새로운 뷰 제목")
        expect(json_response[:data][:category][:slug]).to eq("food")
        expect(json_response[:data][:options].size).to eq(2)
      end

      it "선택지가 2개 미만이면 에러를 반환한다" do
        invalid_params = valid_params.deep_dup
        invalid_params[:view][:view_options_attributes] = [ { content: "선택지 하나만" } ]

        post "/views", params: invalid_params, headers: headers

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response[:error][:code]).to eq("VALIDATION_ERROR")
      end

      it "제목이 없으면 에러를 반환한다" do
        invalid_params = valid_params.deep_dup
        invalid_params[:view][:title] = ""

        post "/views", params: invalid_params, headers: headers

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "제목이 너무 짧으면 에러를 반환한다" do
        invalid_params = valid_params.deep_dup
        invalid_params[:view][:title] = "가"

        post "/views", params: invalid_params, headers: headers

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "인증되지 않은 사용자" do
      it "401 에러를 반환한다" do
        post "/views", params: valid_params

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "PATCH /views/:id" do
    let(:view) { create(:view, user: user) }

    context "뷰 소유자" do
      it "제목을 수정한다" do
        patch "/views/#{view.id}", params: { view: { title: "수정된 제목" } }, headers: headers

        expect(response).to have_http_status(:ok)
        expect(json_response[:data][:title]).to eq("수정된 제목")
        expect(json_response[:data][:edited]).to be true
      end

      it "선택지를 추가한다" do
        original_count = view.view_options.count

        patch "/views/#{view.id}",
              params: { view: { view_options_attributes: [ { content: "새 선택지" } ] } },
              headers: headers

        expect(view.reload.view_options.count).to eq(original_count + 1)
      end

      it "선택지를 삭제한다" do
        option_to_delete = view.view_options.first
        # 최소 3개가 있어야 1개 삭제 가능
        view.view_options.create!(content: "추가 선택지")

        patch "/views/#{view.id}",
              params: { view: { view_options_attributes: [ { id: option_to_delete.id, _destroy: true } ] } },
              headers: headers

        expect(response).to have_http_status(:ok)
        expect(view.reload.view_options.find_by(id: option_to_delete.id)).to be_nil
      end
    end

    context "다른 사용자" do
      it "403 에러를 반환한다" do
        patch "/views/#{view.id}",
              params: { view: { title: "해킹 시도" } },
              headers: auth_headers(other_user)

        expect(response).to have_http_status(:forbidden)
      end
    end

    context "인증되지 않은 사용자" do
      it "401 에러를 반환한다" do
        patch "/views/#{view.id}", params: { view: { title: "수정" } }

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "DELETE /views/:id" do
    let!(:view) { create(:view, user: user) }

    context "뷰 소유자" do
      it "뷰를 삭제한다" do
        expect {
          delete "/views/#{view.id}", headers: headers
        }.to change(View, :count).by(-1)

        expect(response).to have_http_status(:no_content)
      end

      it "연관된 선택지와 투표도 삭제된다" do
        create(:vote, user: other_user, view_option: view.view_options.first)

        expect {
          delete "/views/#{view.id}", headers: headers
        }.to change(Vote, :count).by(-1)
          .and change(ViewOption, :count).by(-2)
      end
    end

    context "다른 사용자" do
      it "403 에러를 반환한다" do
        delete "/views/#{view.id}", headers: auth_headers(other_user)

        expect(response).to have_http_status(:forbidden)
        expect(View.find_by(id: view.id)).to be_present
      end
    end
  end
end
