# module BelongsToAccount

#   def self.included(base)
#     base.extend ClassMethods
#   end

#   module ClassMethods
#     def belongs_to_account
#       belongs_to :account, :class_name => '::Account'
#       default_scope do
#         where(:account_id => ::Account.current.id) if ::Account.current
#       end
#       send :include, InstanceMethods
#     end
#   end

#   module InstanceMethods
#     def account
#       ::Account.current || super
#     end
#   end
# end
# Rails.logger.info("In DJ initializer!!!")
# puts("*"*50)
# module Delayed
#   class Job < ActiveRecord::Base
#     self.table_name = "delayed_jobs"
#     attr_accessor :job_owner_id, :job_owner_type
#     belongs_to :job_owner, :polymorphic => true

#   #   include Activities::ActivityConstants
#     before_save :set_account
#     # before_save :check_ram

#     private

#       def set_account
#         puts("@"*50)
#         # binding.pry
#         #self.account ||= Account.current
#       end
#   end
# end

# module Delayed
# 	module MessageSending
# 		def send_at(time, method, options = {}, *args)
#       options[:run_at] = time
#       __delay__(options).__send__(method, *args)
#     end
#   end

#   class PerformableMethod
#   	def after(job)
#     end

#     def success(job)
#     end

#     def error(job,error)
#     end
#   end

  # set max_attempts to 5 and sleepdelay to the minimum time zone difference which is 15 minutes. (15*60)
  Delayed::Worker.max_attempts = 5
  Delayed::Worker.sleep_delay = 20
  Delayed::Worker.destroy_failed_jobs = false
  Delayed::Worker.delay_jobs = !Rails.env.test?
  Delayed::Worker.max_run_time = 5.minutes
  # Delayed::Worker.logger = Logger.new(File.join(Rails.root, 'log', 'delayed_job.log'))
# end
