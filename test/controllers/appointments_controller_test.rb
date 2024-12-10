require_relative '../test_helper'

class AppointmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @appointment = appointments(:one)
  end

  test "should get index" do
    get appointments_url, as: :json
    assert_response :success
  end

  test "should create appointment" do
    assert_difference('Appointment.count') do
      post appointments_url, params: { appointment: { account_id: @appointment.account_id, agent_id: @appointment.agent_id, client_id: @appointment.client_id, end_time: @appointment.end_time, notes: @appointment.notes, other_info: @appointment.other_info, start_time: @appointment.start_time } }, as: :json
    end

    assert_response 201
  end

  test "should show appointment" do
    get appointment_url(@appointment), as: :json
    assert_response :success
  end

  test "should update appointment" do
    patch appointment_url(@appointment), params: { appointment: { account_id: @appointment.account_id, agent_id: @appointment.agent_id, client_id: @appointment.client_id, end_time: @appointment.end_time, notes: @appointment.notes, other_info: @appointment.other_info, start_time: @appointment.start_time } }, as: :json
    assert_response 200
  end

  test "should destroy appointment" do
    assert_difference('Appointment.count', -1) do
      delete appointment_url(@appointment), as: :json
    end

    assert_response 204
  end
end
