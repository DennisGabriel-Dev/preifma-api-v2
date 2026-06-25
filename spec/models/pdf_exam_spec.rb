require "rails_helper"

RSpec.describe PdfExam, type: :model do
  it "includes expected ransackable attributes" do
    attrs = PdfExam.ransackable_attributes
    expect(attrs).to include("year", "type_pdf", "title")
  end

  it "supports type_pdf enum" do
    exam = PdfExam.new(type_pdf: :integrated)
    expect(exam).to be_integrated
  end
end
