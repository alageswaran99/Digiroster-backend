class Signup
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :data

  $default_shard_name = 'shard_1'
  $default_pod = 'us-east'
  $default_region = 'us-east-1'

  def initialize(_data = nil)
    pre_filled = {
      account: {
        name: 'freshcare-stg',
        # full_domain: 'freshcare-stg.herokuapp.com',
        full_domain: 'renshiners.freshcare.com',
        time_zone: 'Chennai'
      },
      user: {
        first_name: 'Ramkumar',
        last_name: 'Rajendran',
        mobile: '9629978167',
        email: 'arj.ramkumar@gmail.com'
      }
    }
    @data = _data.nil? ? pre_filled : _data
  end

  def save
    shard = ShardMapping.create(shard_name: $default_shard_name, status: :inprogress, pod_info: $default_pod, region: $default_region)
    ActiveRecord::Base.transaction do
      dm = DomainMapping.new(account_id: shard.id, domain: data[:account][:full_domain])
      account = Account.new(data[:account])
      account.id = shard.id
      account.contact_info = data[:user]
      user = Agent.new(first_name: data[:user][:first_name], last_name: data[:user][:last_name], mobile: data[:user][:mobile], email: data[:user][:email])
      user.password = 'test1234'
      user.password_confirmation = 'test1234'
      user.account_id = account.id
      if Rails.env.development? || Rails.env.test?
        user.confirmed_at = Time.now
      end

      account.save!
      user.save!
      dm.save!
      shard.status = 200
      shard.save
      account.make_current
      user.make_current
    end
    populate_seed_data(Account.current, User.current)
    Account.current
  end

  def populate_seed_data(account, user)
    PopulateAccountSeed.new.populate_for(account, user)
  end

  def save!
    
  end
end