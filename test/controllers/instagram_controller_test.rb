require 'test_helper'

class InstagramControllerTest < ActionController::TestCase

  test "should get instagram info" do
    post :searchTag, {'tag' => 'pugdog', 'access_token' => '2019746130.59a3f2b.86a0135240404ed5b908a14c0a2d9402'}
    assert_response :success
  end

  test "should return bad request error" do
    post :searchTag, {'tag' => 'pugdog'}
    assert_response :bad_request
  end

  test "should return empty JSON if get fails" do
    controller = HomeController.new
    uri = "http://www.google.com"
    access_token = ''

    assert_equal({}, controller.get(uri, access_token))
  end

  test "should return json from instagram URL" do
    controller = HomeController.new
    uri = 'https://api.instagram.com/v1/tags/pugdog'
    access_token = "2019746130.59a3f2b.86a0135240404ed5b908a14c0a2d9402"

    result_data = {"meta"=> {"code"=> 200}, "data"=> {"media_count"=> 0, "name"=> "fsdgsdfdssd"}}
    assert_equal(result_data, controller.get(uri, access_token))
  end

  

  
end


