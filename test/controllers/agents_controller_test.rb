require_relative '../test_helper'

class AgentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    host! my_account.full_domain
  end

  test "should get index" do
    create_few_agents
    get agents_url, as: :json, headers: {'Authorization' => auth_token}
    assert_response :success
  end

  test "should create agent" do
    post agents_url, params: generate_agent, as: :json, headers: {'Authorization' => auth_token}
    assert_response 201
  end

  test "should show agent" do
    create_agent
    get agent_url(@agent), as: :json, headers: {'Authorization' => auth_token}
    assert_response :success
  end

  test "should update agent" do
    create_agent
    patch agent_url(@agent), params: generate_agent.except(:email), as: :json, headers: {'Authorization' => auth_token}
    assert_response 200
  end

  test "should destroy agent" do
    create_agent
    delete agent_url(@agent), as: :json, headers: {'Authorization' => auth_token}
    assert_response 401
  end
end
