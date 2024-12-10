module Utils
  module ClientHelper
    def generate_client
      {
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name,
        middle_name: Faker::Name.middle_name,
        email: Faker::Internet.email,
        address: Faker::Address.full_address,
        title: User::TITLE_MAPPINGS.values.sample,
        gender: User::GENDER_MAPPINGS.values.sample,
        region_ids: few_region_ids,
        services: Faker::Lorem.words(number: 4),
        keynote: Faker::Lorem.words(number: rand(5..10)).join(' '),
        dob: Faker::Time.between(from: 50.year.ago, to: 30.year.ago)
      }
    end

    def few_region_ids
      create_few_regions.map { |e| e.id }
    end

    def create_client(account = my_account)
      @client = account.clients.new(generate_client)
      @client.save
      @client
    end

    def create_few_clients
      5.times.collect do
        create_client
      end
    end
  end
end
include Utils::ClientHelper