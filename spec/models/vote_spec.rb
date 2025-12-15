# frozen_string_literal: true

require "rails_helper"

RSpec.describe Vote, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:view_option) }
  end

  describe "validations" do
    let(:user) { create(:user) }
    let(:view) { create(:view) }
    let(:view_option) { view.view_options.first }

    before do
      create(:vote, user: user, view_option: view_option)
    end

    it "같은 선택지에 중복 투표할 수 없다" do
      duplicate_vote = build(:vote, user: user, view_option: view_option)
      expect(duplicate_vote).not_to be_valid
      expect(duplicate_vote.errors[:user_id]).to include("이미 투표했습니다")
    end

    describe "#one_vote_per_view" do
      it "같은 View의 다른 선택지에도 투표할 수 없다" do
        other_option = view.view_options.second
        another_vote = build(:vote, user: user, view_option: other_option)

        expect(another_vote).not_to be_valid
        expect(another_vote.errors[:base]).to include("이 View에 이미 투표했습니다")
      end

      it "다른 View에는 투표할 수 있다" do
        other_view = create(:view)
        new_vote = build(:vote, user: user, view_option: other_view.view_options.first)

        expect(new_vote).to be_valid
      end
    end
  end

  describe "callbacks" do
    let(:view) { create(:view) }
    let(:user) { create(:user) }
    let(:view_option) { view.view_options.first }

    describe "#increment_view_votes_count" do
      it "투표 생성 시 View의 votes_count를 증가시킨다" do
        expect {
          create(:vote, user: user, view_option: view_option)
        }.to change { view.reload.votes_count }.from(0).to(1)
      end
    end

    describe "#decrement_view_votes_count" do
      it "투표 삭제 시 View의 votes_count를 감소시킨다" do
        vote = create(:vote, user: user, view_option: view_option)

        expect {
          vote.destroy
        }.to change { view.reload.votes_count }.from(1).to(0)
      end
    end
  end

  describe "투표 시나리오" do
    let(:view) { create(:view, :with_many_options) }
    let(:users) { create_list(:user, 5) }

    it "여러 사용자가 각각 다른 선택지에 투표할 수 있다" do
      users.each_with_index do |user, index|
        option = view.view_options[index % view.view_options.count]
        expect {
          create(:vote, user: user, view_option: option)
        }.to change { view.reload.votes_count }.by(1)
      end

      expect(view.votes_count).to eq(5)
    end

    it "한 선택지에 여러 사용자가 투표할 수 있다" do
      option = view.view_options.first
      users.each do |user|
        create(:vote, user: user, view_option: option)
      end

      expect(option.votes.count).to eq(5)
    end
  end

  describe "factory" do
    it "유효한 팩토리를 가진다" do
      expect(build(:vote)).to be_valid
    end
  end
end
