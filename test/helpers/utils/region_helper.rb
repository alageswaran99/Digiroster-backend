module Utils
  module RegionHelper
    def generate_region
      {
        name: Faker::Lorem.sentences.first,
        address: Faker::Address.full_address
      }
    end

    def create_region(account = Account.current)
      @region = account.regions.new(generate_region)
      @region.save
      @region
    end

    def create_few_regions
      5.times.collect do
        create_region
      end
    end
  end
end
include Utils::RegionHelper