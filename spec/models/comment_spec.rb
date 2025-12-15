# frozen_string_literal: true

require "rails_helper"

RSpec.describe Comment, type: :model do
  describe "associations" do
    it { should belong_to(:view) }
    it { should belong_to(:user) }
  end

  describe "validations" do
    it { should validate_presence_of(:content) }
    it { should validate_length_of(:content).is_at_least(1).is_at_most(2000) }
  end

  describe "cascade delete" do
    let(:view) { create(:view, :with_comments) }

    it "View 삭제 시 연관된 댓글도 삭제된다" do
      comment_count = view.comments.count
      expect {
        view.destroy
      }.to change(Comment, :count).by(-comment_count)
    end

    it "User 삭제 시 작성한 댓글도 삭제된다" do
      user = view.comments.first.user
      user_comments_count = user.comments.count
      expect {
        user.destroy
      }.to change(Comment, :count).by(-user_comments_count)
    end
  end

  describe "factory" do
    it "유효한 팩토리를 가진다" do
      expect(build(:comment)).to be_valid
    end

    it ":long_content trait가 동작한다" do
      comment = build(:comment, :long_content)
      expect(comment.content.length).to be > 100
    end

    it ":short_content trait가 동작한다" do
      comment = build(:comment, :short_content)
      expect(comment.content).to eq("좋아요!")
    end
  end
end
