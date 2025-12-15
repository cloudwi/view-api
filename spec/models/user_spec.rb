# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  describe "associations" do
    it { should have_many(:views).dependent(:destroy) }
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_many(:votes).dependent(:destroy) }
  end

  describe "validations" do
    it "닉네임은 유니크해야 한다" do
      existing_user = create(:user)
      new_user = build(:user)
      new_user.nickname = existing_user.nickname

      expect(new_user).not_to be_valid
      expect(new_user.errors[:nickname]).to include("has already been taken")
    end

    it "닉네임은 nil일 수 있다" do
      user = build(:user, nickname: nil)
      # before_create callback이 닉네임을 생성하기 전 상태에서는 nil 허용
      user.valid?
      expect(user.errors[:nickname]).to be_empty
    end
  end

  describe "callbacks" do
    describe "#generate_nickname" do
      it "자동으로 닉네임을 생성한다" do
        user = User.create!(email: "test@example.com", provider: "kakao", uid: "123")
        expect(user.nickname).to be_present
      end

      it "중복되지 않는 닉네임을 생성한다" do
        users = 10.times.map do |i|
          User.create!(email: "test#{i}@example.com", provider: "kakao", uid: "uid_#{i}")
        end
        nicknames = users.map(&:nickname)
        expect(nicknames.uniq.size).to eq(users.size)
      end
    end
  end

  describe ".from_omniauth" do
    let(:auth) do
      OpenStruct.new(
        provider: "kakao",
        uid: "kakao_123",
        info: OpenStruct.new(email: "kakao@example.com")
      )
    end

    context "신규 사용자인 경우" do
      it "새 사용자를 생성한다" do
        expect { User.from_omniauth(auth) }.to change(User, :count).by(1)
      end

      it "올바른 정보로 사용자를 생성한다" do
        user = User.from_omniauth(auth)
        expect(user.provider).to eq("kakao")
        expect(user.uid).to eq("kakao_123")
        expect(user.email).to eq("kakao@example.com")
      end
    end

    context "기존 사용자인 경우" do
      before do
        User.from_omniauth(auth)
      end

      it "새 사용자를 생성하지 않는다" do
        expect { User.from_omniauth(auth) }.not_to change(User, :count)
      end

      it "기존 사용자를 반환한다" do
        user = User.from_omniauth(auth)
        expect(user).to eq(User.find_by(provider: "kakao", uid: "kakao_123"))
      end
    end

    context "이메일이 없는 경우" do
      let(:auth_without_email) do
        OpenStruct.new(
          provider: "kakao",
          uid: "kakao_456",
          info: OpenStruct.new(email: nil)
        )
      end

      it "uid 기반 이메일을 생성한다" do
        user = User.from_omniauth(auth_without_email)
        expect(user.email).to eq("kakao_456@kakao.com")
      end
    end
  end

  describe "factory" do
    it "유효한 팩토리를 가진다" do
      expect(build(:user)).to be_valid
    end
  end
end
