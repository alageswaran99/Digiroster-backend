class VaccineJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Rails.logger.info("In vaccine worker...")
    status = Vaccine.new.check_availability
    if status
      Rails.logger.info("Vaccine Job Complete...")
    else
      VaccineJob.set(wait_until: 1.minute.from_now).perform_later(*args)
    end
  end
end