require_relative '../test_helper'

class RegionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    host! my_account.full_domain
  end

  test "should get index" do
    create_few_regions
    get regions_url, as: :json, headers: {'Authorization' => auth_token}
    assert_response :success
  end

  test "should create region" do
    post regions_url, params: generate_region, as: :json, headers: {'Authorization' => auth_token}
    assert_response 201
  end

  test "should show region" do
    create_region
    get region_url(@region), as: :json, headers: {'Authorization' => auth_token}
    assert_response :success
  end

  test "should update region" do
    create_region
    patch region_url(@region), params: generate_region, as: :json, headers: {'Authorization' => auth_token}
    assert_response 200
  end

  test "should destroy region" do
    create_region
    delete region_url(@region), as: :json, headers: {'Authorization' => auth_token}
    assert_response 401
  end
end
