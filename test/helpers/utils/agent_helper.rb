module Utils
  module AgentHelper
    def generate_agent
      {
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name,
        middle_name: Faker::Name.middle_name,
        email: Faker::Internet.email,
        address: Faker::Address.full_address,
        title: User::TITLE_MAPPINGS.values.sample,
        gender: User::GENDER_MAPPINGS.values.sample,
        region_ids: few_region_ids,
        role_ids: [my_account.role_ids.sample]
      }
    end

    def few_region_ids
      create_few_regions.map { |e| e.id }
    end

    def create_agent(account = my_account)
      @agent = account.agents.new(generate_agent)
      @agent.save
      @agent
    end

    def create_few_agents
      5.times.collect do
        create_agent
      end
    end
  end
end
include Utils::AgentHelper