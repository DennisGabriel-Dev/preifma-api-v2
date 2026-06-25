require "rails_helper"

RSpec.describe UserAnswer, type: :model do
  let(:user) { users(:one) }
  let(:question) { questions(:two) }
  let(:answer) { answers(:two_wrong) }

  it "copies answer correctness on create" do
    user_answer = UserAnswer.create!(user: user, question: question, answer: answer)
    expect(user_answer.correct).to eq(false)
  end

  it "updates user streak on create" do
    user.update_columns(current_streak: 0, last_offensive_at: nil)

    UserAnswer.create!(user: user, question: question, answer: answer)

    expect(user.reload.current_streak).to eq(1)
  end

  it "scopes count answers by user" do
    scope = UserAnswer.count_user_answers(user.id)
    expect(scope).to exist
    expect(scope).to respond_to(:count_user_correct_answers)
  end
end
