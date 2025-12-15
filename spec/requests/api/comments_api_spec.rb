# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Comments API", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:view) { create(:view, user: other_user) }
  let(:headers) { auth_headers(user) }

  describe "GET /views/:view_id/comments" do
    before do
      create_list(:comment, 5, view: view)
    end

    it "댓글 목록을 반환한다" do
      get "/views/#{view.id}/comments"

      expect(response).to have_http_status(:ok)
      expect(json_response[:data].size).to eq(5)
    end

    it "오래된 순으로 정렬된다" do
      get "/views/#{view.id}/comments"

      dates = json_response[:data].map { |c| c[:created_at] }
      expect(dates).to eq(dates.sort)
    end

    it "작성자 정보를 포함한다" do
      get "/views/#{view.id}/comments"

      json_response[:data].each do |comment|
        expect(comment[:author]).to include(:id, :nickname)
      end
    end

    it "존재하지 않는 View는 404를 반환한다" do
      get "/views/99999/comments"

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /views/:view_id/comments" do
    let(:valid_params) { { comment: { content: "좋은 의견이네요!" } } }

    context "인증된 사용자" do
      it "댓글을 생성한다" do
        expect {
          post "/views/#{view.id}/comments", params: valid_params, headers: headers
        }.to change(Comment, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(json_response[:data][:content]).to eq("좋은 의견이네요!")
        expect(json_response[:data][:author][:id]).to eq(user.id)
      end

      it "내용이 없으면 에러를 반환한다" do
        post "/views/#{view.id}/comments",
             params: { comment: { content: "" } },
             headers: headers

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "내용이 너무 길면 에러를 반환한다" do
        post "/views/#{view.id}/comments",
             params: { comment: { content: "a" * 2001 } },
             headers: headers

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "존재하지 않는 View에 댓글을 달 수 없다" do
        post "/views/99999/comments", params: valid_params, headers: headers

        expect(response).to have_http_status(:not_found)
      end
    end

    context "인증되지 않은 사용자" do
      it "401 에러를 반환한다" do
        post "/views/#{view.id}/comments", params: valid_params

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "PATCH /views/:view_id/comments/:id" do
    let!(:comment) { create(:comment, view: view, user: user) }

    context "댓글 작성자" do
      it "댓글을 수정한다" do
        patch "/views/#{view.id}/comments/#{comment.id}",
              params: { comment: { content: "수정된 댓글" } },
              headers: headers

        expect(response).to have_http_status(:ok)
        expect(json_response[:data][:content]).to eq("수정된 댓글")
      end

      it "빈 내용으로 수정할 수 없다" do
        patch "/views/#{view.id}/comments/#{comment.id}",
              params: { comment: { content: "" } },
              headers: headers

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "다른 사용자" do
      it "403 에러를 반환한다" do
        patch "/views/#{view.id}/comments/#{comment.id}",
              params: { comment: { content: "해킹" } },
              headers: auth_headers(other_user)

        expect(response).to have_http_status(:forbidden)
      end
    end

    context "인증되지 않은 사용자" do
      it "401 에러를 반환한다" do
        patch "/views/#{view.id}/comments/#{comment.id}",
              params: { comment: { content: "수정" } }

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "DELETE /views/:view_id/comments/:id" do
    let!(:comment) { create(:comment, view: view, user: user) }

    context "댓글 작성자" do
      it "댓글을 삭제한다" do
        expect {
          delete "/views/#{view.id}/comments/#{comment.id}", headers: headers
        }.to change(Comment, :count).by(-1)

        expect(response).to have_http_status(:no_content)
      end
    end

    context "다른 사용자" do
      it "403 에러를 반환한다" do
        delete "/views/#{view.id}/comments/#{comment.id}", headers: auth_headers(other_user)

        expect(response).to have_http_status(:forbidden)
        expect(Comment.find_by(id: comment.id)).to be_present
      end
    end

    it "존재하지 않는 댓글은 404를 반환한다" do
      delete "/views/#{view.id}/comments/99999", headers: headers

      expect(response).to have_http_status(:not_found)
    end
  end
end
