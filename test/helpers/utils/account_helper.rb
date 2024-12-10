module Utils
  module AccountHelper

    def generate_account
      domain_word = Faker::Internet.domain_word
      {
        account: {
          name: domain_word.titleize,
          full_domain: "#{domain_word}.freshcare.com",
          time_zone: 'Chennai'
        },
        user: {
          first_name: Faker::Name.name,
          last_name: Faker::Name.name,
          mobile: Faker::PhoneNumber.cell_phone_with_country_code,
          email: Faker::Internet.email
        }
      }
    end

    def create_account
      signup = Signup.new(generate_account)
      signup.save
      user = User.current
      user.password = "test1234"
      user.password_confirmation = "test1234"
      user.save
    end

    def auth
      {
          "user": {
              "email": my_user.email,
              "password": "test1234"
          }
      }
    end

    def auth_token
      return Thread.current[:auth_token] if Thread.current[:auth_token]

      post(user_session_url, params: auth, as: :json)
      Thread.current[:auth_token] = response.headers['Authorization']
    end

    def my_user
      return User.current if User.current

      if User.current.nil?
        user = my_account.users.first.make_current
      end
    end

    def my_account
      return Account.current if Account.current

      if Account.last.nil?
        create_account
      elsif Account.last
        Account.last.make_current
      end
      Account.current
    end
  end
end
include Utils::AccountHelper