# frozen_string_literal: true

require "rails_helper"

RSpec.describe ViewOption, type: :model do
  describe "associations" do
    it { should belong_to(:view) }
    it { should have_many(:votes).dependent(:destroy) }
  end

  describe "validations" do
    it { should validate_presence_of(:content) }
    it { should validate_length_of(:content).is_at_least(1).is_at_most(100) }
  end

  describe "투표 통계" do
    let(:view) { create(:view) }
    let(:option) { view.view_options.first }
    let(:users) { create_list(:user, 5) }

    before do
      users.each do |user|
        create(:vote, user: user, view_option: option)
      end
    end

    it "투표 수를 정확히 계산한다" do
      expect(option.votes.count).to eq(5)
    end
  end

  describe "cascade delete" do
    let(:view) { create(:view) }
    let(:option) { view.view_options.first }
    let(:user) { create(:user) }

    before do
      create(:vote, user: user, view_option: option)
    end

    it "선택지 삭제 시 연관된 투표도 삭제된다" do
      expect {
        option.destroy
      }.to change(Vote, :count).by(-1)
    end
  end

  describe "factory" do
    it "유효한 팩토리를 가진다" do
      view = create(:view)
      option = build(:view_option, view: view)
      expect(option).to be_valid
    end
  end
end
