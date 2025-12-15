# frozen_string_literal: true

require "rails_helper"

RSpec.describe Category, type: :model do
  describe "associations" do
    it { should have_many(:views).dependent(:restrict_with_error) }
  end

  describe "validations" do
    subject { build(:category) }

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:slug) }
    it { should validate_uniqueness_of(:slug) }
    it { should validate_numericality_of(:display_order).only_integer }
  end

  describe "scopes" do
    let!(:active_category) { create(:category, active: true, display_order: 2) }
    let!(:inactive_category) { create(:category, :inactive, display_order: 1) }
    let!(:first_category) { create(:category, active: true, display_order: 0) }

    describe ".active" do
      it "활성화된 카테고리만 반환한다" do
        result = Category.active
        expect(result).to include(active_category, first_category)
        expect(result).not_to include(inactive_category)
      end
    end

    describe ".ordered" do
      it "display_order 기준으로 정렬한다" do
        result = Category.ordered
        expect(result.first).to eq(first_category)
      end
    end
  end

  describe ".default" do
    context "daily 카테고리가 있을 때" do
      let!(:daily) { create(:category, :daily) }

      it "daily 카테고리를 반환한다" do
        expect(Category.default).to eq(daily)
      end
    end

    context "daily 카테고리가 없을 때" do
      it "nil을 반환한다" do
        expect(Category.default).to be_nil
      end
    end
  end

  describe "dependent restrict" do
    let(:category) { create(:category) }
    let!(:view) { create(:view, category: category) }

    it "연결된 뷰가 있으면 삭제할 수 없다" do
      expect { category.destroy }.not_to change(Category, :count)
      expect(category.errors[:base]).to include("Cannot delete record because dependent views exist")
    end
  end

  describe "factory" do
    it "유효한 팩토리를 가진다" do
      expect(build(:category)).to be_valid
    end

    it ":daily trait가 동작한다" do
      category = create(:category, :daily)
      expect(category.slug).to eq("daily")
    end

    it ":food trait가 동작한다" do
      category = create(:category, :food)
      expect(category.slug).to eq("food")
    end

    it ":inactive trait가 동작한다" do
      category = create(:category, :inactive)
      expect(category.active).to be false
    end
  end
end
