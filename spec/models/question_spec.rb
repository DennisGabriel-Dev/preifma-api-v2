require "rails_helper"

RSpec.describe Question, type: :model do
  let(:question) { questions(:one) }

  it "validates required fields" do
    invalid = Question.new
    expect(invalid).not_to be_valid
    expect(invalid.errors.attribute_names).to include(:title, :description, :year, :subject)
  end

  it "returns correct answer" do
    expect(question.correct_answer).to eq(answers(:one_correct))
  end

  it "returns empty image_urls without attachments" do
    expect(question.image_urls).to eq([])
  end

  it "returns urls for attached images" do
    question.images.attach(
      io: StringIO.new("fake"),
      filename: "test.png",
      content_type: "image/png"
    )

    urls = question.image_urls
    expect(urls.size).to eq(1)
    expect(urls.first).to include("localhost:3001")
  end

  it "logs and skips broken blob url" do
    question.images.attach(
      io: StringIO.new("fake"),
      filename: "test.png",
      content_type: "image/png"
    )

    helpers = Rails.application.routes.url_helpers
    original = helpers.method(:rails_blob_url)
    helpers.define_singleton_method(:rails_blob_url) { |*| raise "boom" }

    begin
      expect(question.image_urls).to eq([])
    ensure
      helpers.define_singleton_method(:rails_blob_url, original)
    end
  end

  it "includes expected ransackable attributes" do
    expect(Question.ransackable_attributes).to include("subject", "year")
  end
end
