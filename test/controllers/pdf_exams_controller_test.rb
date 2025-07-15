require "test_helper"

class PdfExamsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get pdf_exams_index_url
    assert_response :success
  end

  test "should get show" do
    get pdf_exams_show_url
    assert_response :success
  end

  test "should get new" do
    get pdf_exams_new_url
    assert_response :success
  end

  test "should get create" do
    get pdf_exams_create_url
    assert_response :success
  end

  test "should get edit" do
    get pdf_exams_edit_url
    assert_response :success
  end

  test "should get update" do
    get pdf_exams_update_url
    assert_response :success
  end

  test "should get destroy" do
    get pdf_exams_destroy_url
    assert_response :success
  end
end
