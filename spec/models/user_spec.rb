require "rails_helper"

RSpec.describe User, type: :model do
  let(:user) { users(:one) }

  it "validates email presence and uniqueness" do
    expect(user).to be_valid

    duplicate = User.new(
      email: user.email,
      name: "Outro",
      password: "Senha123",
      password_confirmation: "Senha123"
    )
    expect(duplicate).not_to be_valid
  end

  it "validates password format" do
    invalid = User.new(
      email: "teste@example.com",
      name: "Teste",
      password: "fraca",
      password_confirmation: "fraca"
    )
    expect(invalid).not_to be_valid
  end

  it "generate_reset_password_token sets token and timestamp" do
    user.generate_reset_password_token!
    user.reload

    expect(user.reset_password_token).to be_present
    expect(user.reset_password_sent_at).to be_present
  end

  it "reset_password_token_expired returns false when never sent" do
    user.update_columns(reset_password_sent_at: nil)
    expect(user.reset_password_token_expired?).to be false
  end

  it "reset_password_token_expired returns true after one hour" do
    user.update_columns(reset_password_sent_at: 2.hours.ago)
    expect(user.reset_password_token_expired?).to be true
  end

  it "clear_reset_password_token clears fields" do
    user.generate_reset_password_token!
    user.clear_reset_password_token!
    user.reload

    expect(user.reset_password_token).to be_nil
    expect(user.reset_password_sent_at).to be_nil
  end

  describe "#register_offensive!" do
    it "starts streak on first day" do
      user.update_columns(current_streak: 0, last_offensive_at: nil)
      today = Date.current
      user.register_offensive!(today)

      expect(user.current_streak).to eq(1)
      expect(user.last_offensive_at.to_date).to eq(today)
    end

    it "is idempotent on same day" do
      user.update_columns(current_streak: 3, last_offensive_at: Time.zone.parse("2025-06-17 10:00"))
      user.register_offensive!(Date.new(2025, 6, 17))

      expect(user.reload.current_streak).to eq(3)
    end

    it "increments on consecutive day" do
      user.update_columns(current_streak: 2, last_offensive_at: Time.zone.parse("2025-06-16 10:00"))
      user.register_offensive!(Date.new(2025, 6, 17))

      expect(user.reload.current_streak).to eq(3)
    end

    it "resets after gap" do
      user.update_columns(current_streak: 5, last_offensive_at: Time.zone.parse("2025-06-14 10:00"))
      user.register_offensive!(Date.new(2025, 6, 17))

      expect(user.reload.current_streak).to eq(1)
    end
  end
end
