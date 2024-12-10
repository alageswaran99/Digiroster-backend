class UpdateRecurringJob < ApplicationJob
  queue_as :default

  def perform(*args)
    params = args.first
    Rails.logger.info("In UpdateRecurringJob with params :: #{params.inspect}")
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

    appts = @rt.appointments.includes(:agent_appointments)
    appts.each do |x|
      if x.allow_edit?
        x.destroy
      end
    end
    Rails.logger.info("Completed appointment destroy loop")
    RecurringAppointmentJob.perform_later({task_id: @rt.id, account_id: @rt.account.id, version_id: @rt.version_id})
  end
end