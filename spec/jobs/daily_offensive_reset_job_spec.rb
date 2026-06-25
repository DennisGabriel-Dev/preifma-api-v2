require "rails_helper"

RSpec.describe DailyOffensiveResetJob, type: :job do
  let(:user1) { users(:one) }

  it "resets streak for inactive users" do
    user1.update_columns(current_streak: 5, last_offensive_at: 3.days.ago.beginning_of_day)

    described_class.perform_now

    expect(user1.reload.current_streak).to eq(0)
  end

  it "keeps streak for users active yesterday" do
    user1.update_columns(current_streak: 5, last_offensive_at: Time.zone.yesterday.beginning_of_day)

    described_class.perform_now

    expect(user1.reload.current_streak).to eq(5)
  end

  it "keeps streak for users active today" do
    user1.update_columns(current_streak: 5, last_offensive_at: Time.zone.today.beginning_of_day)

    described_class.perform_now

    expect(user1.reload.current_streak).to eq(5)
  end

  it "handles users with no offensive activity" do
    user1.update_columns(current_streak: 0, last_offensive_at: nil)

    expect { described_class.perform_now }.not_to raise_error
  end
end
