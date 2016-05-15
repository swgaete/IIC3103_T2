require 'test_helper'
require 'instagram'

class InstagramControllerTest < ActionController::TestCase

  test "should get instagram info" do
    post :searchTag, {'tag' => 'pugdog', 'access_token' => '2019746130.59a3f2b.86a0135240404ed5b908a14c0a2d9402'}
    assert_response :success
  end

  test "should return bad request error" do
    post :searchTag, {'tag' => 'pugdog'}
    assert_response :bad_request
  end

  test "should return json from instagram URL" do
    client = Instagram.client(:access_token => '2019746130.59a3f2b.86a0135240404ed5b908a14c0a2d9402')
    response = client.tag_recent_media('pugdog')
    assert_equal Array, response.class
  end

  

  
end


