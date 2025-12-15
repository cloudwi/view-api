# frozen_string_literal: true

require "rails_helper"

RSpec.describe View, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:category) }
    it { should have_many(:view_options).dependent(:destroy) }
    it { should have_many(:comments).dependent(:destroy) }
  end

  describe "validations" do
    it { should validate_presence_of(:title) }
    it { should validate_length_of(:title).is_at_least(2).is_at_most(200) }
    it { should validate_presence_of(:category_id) }

    describe "#options_count_within_range" do
      it "선택지가 2개 미만이면 유효하지 않다" do
        view = build(:view)
        view.view_options.clear
        view.view_options.build(content: "선택지 1개만")

        expect(view).not_to be_valid
        expect(view.errors[:view_options]).to include("최소 2개의 선택사항이 필요합니다")
      end

      it "선택지가 20개 초과면 유효하지 않다" do
        view = build(:view)
        view.view_options.clear
        21.times { |i| view.view_options.build(content: "선택지 #{i}") }

        expect(view).not_to be_valid
        expect(view.errors[:view_options]).to include("최대 20개의 선택사항만 가능합니다")
      end

      it "선택지가 2~20개면 유효하다" do
        view = build(:view)
        expect(view).to be_valid
      end
    end
  end

  describe "category association" do
    it "카테고리를 통해 뷰를 조회할 수 있다" do
      category = create(:category, :food)
      view = create(:view, category: category)
      expect(view.category.slug).to eq("food")
    end

    it "카테고리 정보에 접근할 수 있다" do
      view = create(:view, :food)
      expect(view.category.name).to be_present
      expect(view.category.slug).to be_present
    end
  end

  describe "scopes" do
    let!(:user1) { create(:user) }
    let!(:user2) { create(:user) }
    let!(:view1) { create(:view, user: user1, title: "맛집 추천해주세요") }
    let!(:view2) { create(:view, user: user2, title: "여행지 추천") }
    let!(:view3) { create(:view, user: user1, title: "오늘 점심 뭐먹지") }

    describe ".search_by_title" do
      it "제목으로 검색한다" do
        result = View.search_by_title("추천")
        expect(result).to include(view1, view2)
        expect(result).not_to include(view3)
      end

      it "빈 쿼리면 전체를 반환한다" do
        result = View.search_by_title("")
        expect(result).to include(view1, view2, view3)
      end
    end

    describe ".authored_by" do
      it "특정 사용자의 뷰만 반환한다" do
        result = View.authored_by(user1.id)
        expect(result).to include(view1, view3)
        expect(result).not_to include(view2)
      end
    end

    describe ".sort_by_latest" do
      it "최신순으로 정렬한다" do
        result = View.sort_by_latest
        expect(result.first).to eq(view3)
      end
    end

    describe ".sort_by_most_votes" do
      before do
        # view1에 투표 추가
        3.times do
          user = create(:user)
          create(:vote, user: user, view_option: view1.view_options.first)
        end
      end

      it "투표 많은 순으로 정렬한다" do
        result = View.sort_by_most_votes
        expect(result.first).to eq(view1)
      end
    end

    describe ".voted_by / .not_voted_by" do
      let(:voter) { create(:user) }

      before do
        create(:vote, user: voter, view_option: view1.view_options.first)
      end

      it ".voted_by는 투표한 뷰만 반환한다" do
        result = View.voted_by(voter)
        expect(result).to include(view1)
        expect(result).not_to include(view2, view3)
      end

      it ".not_voted_by는 투표하지 않은 뷰만 반환한다" do
        result = View.not_voted_by(voter)
        expect(result).not_to include(view1)
        expect(result).to include(view2, view3)
      end
    end
  end

  describe ".sorted_by" do
    it "latest가 기본값이다" do
      expect(View.sorted_by(nil).to_sql).to include("created_at")
    end

    it "most_votes 정렬을 지원한다" do
      expect(View.sorted_by("most_votes").to_sql).to include("votes_count")
    end
  end

  describe "counter cache" do
    let(:view) { create(:view) }
    let(:user) { create(:user) }

    it "투표 시 votes_count가 증가한다" do
      expect {
        create(:vote, user: user, view_option: view.view_options.first)
      }.to change { view.reload.votes_count }.by(1)
    end

    it "투표 삭제 시 votes_count가 감소한다" do
      vote = create(:vote, user: user, view_option: view.view_options.first)
      expect {
        vote.destroy
      }.to change { view.reload.votes_count }.by(-1)
    end
  end

  describe "factory" do
    it "유효한 팩토리를 가진다" do
      expect(build(:view)).to be_valid
    end

    it ":food trait가 동작한다" do
      view = create(:view, :food)
      expect(view.category.slug).to eq("food")
    end

    it ":with_votes trait가 동작한다" do
      view = create(:view, :with_votes)
      expect(view.votes_count).to eq(3)
    end

    it ":with_comments trait가 동작한다" do
      view = create(:view, :with_comments)
      expect(view.comments.count).to eq(3)
    end
  end
end
