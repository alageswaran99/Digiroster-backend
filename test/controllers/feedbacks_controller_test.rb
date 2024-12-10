# require 'test_helper'

# class FeedbacksControllerTest < ActionDispatch::IntegrationTest
#   setup do
#     @feedback = feedbacks(:one)
#   end

#   test "should get index" do
#     get feedbacks_url, as: :json
#     assert_response :success
#   end

#   test "should create feedback" do
#     assert_difference('Feedback.count') do
#       post feedbacks_url, params: { feedback: { account_id: @feedback.account_id, agent_id: @feedback.agent_id, appointment_id: @feedback.appointment_id, client_id: @feedback.client_id, description: @feedback.description, note_type: @feedback.note_type, other_info: @feedback.other_info } }, as: :json
#     end

#     assert_response 201
#   end

#   test "should show feedback" do
#     get feedback_url(@feedback), as: :json
#     assert_response :success
#   end

#   test "should update feedback" do
#     patch feedback_url(@feedback), params: { feedback: { account_id: @feedback.account_id, agent_id: @feedback.agent_id, appointment_id: @feedback.appointment_id, client_id: @feedback.client_id, description: @feedback.description, note_type: @feedback.note_type, other_info: @feedback.other_info } }, as: :json
#     assert_response 200
#   end

#   test "should destroy feedback" do
#     assert_difference('Feedback.count', -1) do
#       delete feedback_url(@feedback), as: :json
#     end

#     assert_response 204
#   end
# end
