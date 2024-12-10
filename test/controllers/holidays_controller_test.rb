require "test_helper"

class HolidaysControllerTest < ActionDispatch::IntegrationTest
  setup do
    @holiday = holidays(:one)
  end

  test "should get index" do
    get holidays_url, as: :json
    assert_response :success
  end

  test "should create holiday" do
    assert_difference('Holiday.count') do
      post holidays_url, params: { holiday: { account_id: @holiday.account_id, agent_id: @holiday.agent_id, from_time: @holiday.from_time, leave_type: @holiday.leave_type, reason: @holiday.reason, to_time: @holiday.to_time } }, as: :json
    end

    assert_response 201
  end

  test "should show holiday" do
    get holiday_url(@holiday), as: :json
    assert_response :success
  end

  test "should update holiday" do
    patch holiday_url(@holiday), params: { holiday: { account_id: @holiday.account_id, agent_id: @holiday.agent_id, from_time: @holiday.from_time, leave_type: @holiday.leave_type, reason: @holiday.reason, to_time: @holiday.to_time } }, as: :json
    assert_response 200
  end

  test "should destroy holiday" do
    assert_difference('Holiday.count', -1) do
      delete holiday_url(@holiday), as: :json
    end

    assert_response 204
  end
end
