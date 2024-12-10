require_relative '../test_helper'

class RolesControllerTest < ActionDispatch::IntegrationTest
  setup do
    host! my_account.full_domain
  end

  test "should get index" do
    get roles_url, as: :json, headers: {'Authorization' => auth_token}
    assert_response :success
  end

  test "should show role" do
    role_id = my_account.roles.map { |e| e.id }.sample
    get role_url(role_id), as: :json, headers: {'Authorization' => auth_token}
    assert_response :success
  end

  test "should show few roles - specific_roles" do
    role_ids = my_account.roles.map { |e| e.id }.take(3)
    get specific_roles_roles_url('json'), params: {role_ids: role_ids}, headers: {'Authorization' => auth_token}
    assert_response :success
  end
end
