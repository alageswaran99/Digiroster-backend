class RecurringAppointmentJob < ApplicationJob
  queue_as :default

  def perform(*args)
    params = args.first
    Rails.logger.info("In RecurringAppointmentJob with params :: #{params.inspect}")
    account_id = params[:account_id] || params['account_id']
    task_id = params[:task_id] || params['task_id']
    version_id = params[:version_id] || params['version_id']
    if account_id.nil? || task_id.nil?
      return Rails.logger.error("Something wrong!! Account or task id not present!!")
    end
    @account = Account.find(account_id).make_current
    @rt = @account.recurring_tasks.find_by_id(task_id)
    if @rt.nil?
      Rails.logger.error("Recurring task deleted")
      return
    end
    return Rails.logger.error("version_id mismatch") if @rt.version_id != version_id

    next_job_date = create_future_appointments
    next_job_id = RecurringAppointmentJob.set(wait_until: next_job_date).perform_later(*args)
    Rails.logger.info("Next job ID :: #{next_job_id}")
    Account.reset_current_account
  end

  private

    def create_future_appointments
      moving_pointer = start_date = Date.current
      loop do
        if @rt.scheduled_days.include?(moving_pointer.wday)
          @rt.create_appt(moving_pointer)
        end
        if (moving_pointer - start_date).to_i == 15
          break
        end
        moving_pointer = moving_pointer.next_day
      end
      moving_pointer.next_day.beginning_of_day
    end
end