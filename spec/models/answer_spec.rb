require "rails_helper"

RSpec.describe Answer, type: :model do
  it "validates text presence" do
    answer = Answer.new(text: nil, question: questions(:one))
    expect(answer).not_to be_valid
  end
end
