require_relative '../test_helper'

class ClientsControllerTest < ActionDispatch::IntegrationTest
  setup do
    host! my_account.full_domain
  end

  test "should get index" do
    create_few_clients
    get clients_url, as: :json, headers: {'Authorization' => auth_token}
    assert_response :success
  end

  test "should create client" do
    post clients_url, params: generate_client, as: :json, headers: {'Authorization' => auth_token}
    assert_response 201
  end

  test "should show client" do
    create_client
    get client_url(@client), as: :json, headers: {'Authorization' => auth_token}
    assert_response :success
  end

  test "should update client" do
    create_client
    patch client_url(@client), params: generate_client.except(:email), as: :json, headers: {'Authorization' => auth_token}
    assert_response 200
  end

  test "should destroy client" do
    create_client
    delete client_url(@client), as: :json, headers: {'Authorization' => auth_token}
    assert_response 401
  end
end
