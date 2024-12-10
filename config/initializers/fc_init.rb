if Rails.env.development?
  $raw_sql = Proc.new { |sql| ActiveRecord::Base.connection.execute(sql) }
end

require File.dirname(__FILE__) + "/../../lib/plugins/belongs_to_account/belongs_to_account"

ActiveRecord::Base.send :include, Plugins::BelongsToAccount::BelongsToAccount

# This plugin should be reloaded in development mode.
# if Rails.env.development?
#   ActiveSupport::Dependencies.autoload_once_paths.reject!{|x| x =~ /^#{Regexp.escape(File.dirname(__FILE__))}/}
# end

begin
  $redis = Redis.new(Rails.application.config_for(:redis))
  $redis.ping
rescue Redis::CannotConnectError => e
  Rails.logger.info("Unable to connect to redis...#{e.inspect}")
  $redis_down = true
rescue Exception => other_exception
  Rails.logger.info("Some other exception while configuring redis...#{other_exception.inspect}")
  $redis_down = true
end


class Object
  require 'set'

  BLACKLIST_METHODS = %w(eval instance_eval send __send__ public_send exit exit! abort system exec fork open sleep spawn syscall ` throw).to_set.freeze
  WARNING_METHODS = %w(raise fail).to_set.freeze

  # New method which blacklists some of the riskier methods. To be used instead of .send
  def safe_send(*args, &block)
    if args && args.length > 0
      if WARNING_METHODS.include?(args[0].to_s)
        Rails.logger.error "SecurityError: safe_send called with '#{args[0]}'. Allowing execution. Stack: #{caller}"
      elsif BLACKLIST_METHODS.include?(args[0].to_s)
        Rails.logger.error "SecurityError: safe_send called with '#{args[0]}'. Blocking execution. Stack: #{caller}"
        raise SecurityError
      end
    end
    block_given? ? send(*args, &block) : send(*args)
  end

end

ActiveSupport.on_load(:action_controller) do
  wrap_parameters format: [:json]
end

if Rails.env.development? || Rails.env.test?
  # ActiveRecordQueryTrace.level = :full
  ActiveRecordQueryTrace.enabled = true
  # Optional: other gem config options go here
  # ActiveRecordQueryTrace.colorize = :red
end
