module Scripts
  class General
    def flush_db(delete_confirm = false)
      if delete_confirm == "DB_FLUSH"
        Appointment.destroy_all
        User.where("id != ?", 1).destroy_all
        AllowlistedJwt.destroy_all
        Feedback.destroy_all
        Note.destroy_all
        Delayed::Job.destroy_all
        RecurringTask.destroy_all
      else
        "DB Flush Missing check once"
      end
    end
  end
end
#     def sample_script
#       a = Account.first.make_current
#       cli = a.clients.find(6)
#       cli.group
#       cli.group_id = nil
#       cli.save
#       rt= a.recurring_tasks.last
#       rt
#       current_agent = a.agents.find(5)
#       current_agent.appointments
#       appt = a.appointments.first
#       appt.agent_appointments
#       a.users
#       params = {
#         client_id: 2,
#         notes: "Sample text content",
#         start_time: 15.hours.from_now,
#         end_time: 17.hours.from_now,
#         agent_appointments_attributes: [
#           {
#           agent_id: 4
#         }
#         ]
#       }
#       params = {
#         client_id: 2,
#         notes: "Sample text content",
#         start_time: 15.hours.from_now,
#         end_time: 17.hours.from_now,
#         agent_appointments_attributes: [
#         ]
#       }

#       new_params = {
#         agent_appointments_attributes: [
#         {
#           id: 2,
#           agent_id: 1,
#           status: 'inprogress'
#         }
#       ]
#       }
#       appt.update(new_params)
#       appt = a.appointments.last
#       params = {
#         feedbacks_attributes: [
#           {
#             description: "some random description",
#             note_type: "general",
#             agent_id: "2",
#             services: ["Feeding"]
#           }
#         ]
#       }
#     end

#     def user_confirmation(id)
#       user = User.find(id)
#       user.skip_confirmation!
#       user.save
#     end
#     end
#   end
