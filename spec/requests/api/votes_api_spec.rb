# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Votes API", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:view) { create(:view, user: other_user) }
  let(:option) { view.view_options.first }
  let(:headers) { auth_headers(user) }

  describe "POST /views/:view_id/vote" do
    context "인증된 사용자" do
      it "투표를 생성한다" do
        expect {
          post "/views/#{view.id}/vote", params: { view_option_id: option.id }, headers: headers
        }.to change(Vote, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(json_response[:data][:my_vote][:option_id]).to eq(option.id)
        expect(json_response[:data][:view_id]).to eq(view.id)
      end

      it "View의 votes_count가 증가한다" do
        expect {
          post "/views/#{view.id}/vote", params: { view_option_id: option.id }, headers: headers
        }.to change { view.reload.votes_count }.by(1)
      end

      it "옵션 목록을 반환한다" do
        post "/views/#{view.id}/vote", params: { view_option_id: option.id }, headers: headers

        expect(json_response[:data][:options]).to be_an(Array)
        expect(json_response[:data][:options].size).to eq(view.view_options.count)
      end

      context "이미 투표한 경우" do
        before do
          create(:vote, user: user, view_option: option)
        end

        it "같은 선택지에 중복 투표할 수 없다" do
          post "/views/#{view.id}/vote", params: { view_option_id: option.id }, headers: headers

          expect(response).to have_http_status(:unprocessable_entity)
          expect(json_response[:error][:code]).to eq("VALIDATION_ERROR")
        end

        it "다른 선택지에도 투표할 수 없다" do
          other_option = view.view_options.second

          post "/views/#{view.id}/vote", params: { view_option_id: other_option.id }, headers: headers

          expect(response).to have_http_status(:unprocessable_entity)
          expect(json_response[:error][:message]).to include("이미")
        end
      end

      it "존재하지 않는 View에 투표할 수 없다" do
        post "/views/99999/vote", params: { view_option_id: option.id }, headers: headers

        expect(response).to have_http_status(:not_found)
        expect(json_response[:error][:code]).to eq("NOT_FOUND")
      end

      it "존재하지 않는 선택지에 투표할 수 없다" do
        post "/views/#{view.id}/vote", params: { view_option_id: 99999 }, headers: headers

        expect(response).to have_http_status(:not_found)
        expect(json_response[:error][:code]).to eq("NOT_FOUND")
      end

      it "다른 View의 선택지에 투표할 수 없다" do
        other_view = create(:view)
        wrong_option = other_view.view_options.first

        post "/views/#{view.id}/vote", params: { view_option_id: wrong_option.id }, headers: headers

        expect(response).to have_http_status(:not_found)
      end
    end

    context "인증되지 않은 사용자" do
      it "401 에러를 반환한다" do
        post "/views/#{view.id}/vote", params: { view_option_id: option.id }

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "DELETE /views/:view_id/vote" do
    context "인증된 사용자" do
      context "투표가 있는 경우" do
        before do
          create(:vote, user: user, view_option: option)
        end

        it "투표를 삭제한다" do
          expect {
            delete "/views/#{view.id}/vote", headers: headers
          }.to change(Vote, :count).by(-1)

          expect(response).to have_http_status(:ok)
          expect(json_response[:data][:my_vote]).to be_nil
        end

        it "View의 votes_count가 감소한다" do
          expect {
            delete "/views/#{view.id}/vote", headers: headers
          }.to change { view.reload.votes_count }.by(-1)
        end

        it "투표 결과를 반환한다" do
          delete "/views/#{view.id}/vote", headers: headers

          expect(json_response[:data][:view_id]).to eq(view.id)
          expect(json_response[:data][:options]).to be_an(Array)
        end
      end

      context "투표가 없는 경우" do
        it "404 에러를 반환한다" do
          delete "/views/#{view.id}/vote", headers: headers

          expect(response).to have_http_status(:not_found)
          expect(json_response[:error][:code]).to eq("NOT_FOUND")
        end
      end

      it "존재하지 않는 View에서 투표를 삭제할 수 없다" do
        delete "/views/99999/vote", headers: headers

        expect(response).to have_http_status(:not_found)
        expect(json_response[:error][:code]).to eq("NOT_FOUND")
      end
    end

    context "인증되지 않은 사용자" do
      it "401 에러를 반환한다" do
        delete "/views/#{view.id}/vote"

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "투표 시나리오" do
    let(:users) { create_list(:user, 5) }
    let(:view) { create(:view, :with_many_options) }

    it "여러 사용자가 투표하면 View의 votes_count가 정확하다" do
      users.each_with_index do |u, i|
        option = view.view_options[i % 2]
        post "/views/#{view.id}/vote",
             params: { view_option_id: option.id },
             headers: auth_headers(u)
      end

      expect(view.reload.votes_count).to eq(5)
    end

    it "투표 후 재투표(변경)는 삭제 후 다시 투표해야 한다" do
      # 첫 번째 투표
      post "/views/#{view.id}/vote",
           params: { view_option_id: view.view_options[0].id },
           headers: headers

      expect(response).to have_http_status(:created)

      # 다른 선택지로 변경 시도 (실패)
      post "/views/#{view.id}/vote",
           params: { view_option_id: view.view_options[1].id },
           headers: headers

      expect(response).to have_http_status(:unprocessable_entity)

      # 기존 투표 삭제
      delete "/views/#{view.id}/vote", headers: headers
      expect(response).to have_http_status(:ok)

      # 새 선택지로 투표
      post "/views/#{view.id}/vote",
           params: { view_option_id: view.view_options[1].id },
           headers: headers

      expect(response).to have_http_status(:created)
      expect(json_response[:data][:my_vote][:option_id]).to eq(view.view_options[1].id)
    end
  end
end
