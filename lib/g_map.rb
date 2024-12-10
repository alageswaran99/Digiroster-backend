class GMap
  GRACE_DISTANCE = 1000

  def initialize(options = {})
    @options = HashWithIndifferentAccess.new(options)
    @map_response = {}
  end

  def checkin_allowed?
    make_api
    parsed_distance < GRACE_DISTANCE
  end

  def fetch_response
    JSON.parse(@map_response)
  end

  def fetch_distance
    parsed_distance
  end

  private

    def build_params
      origin_points = "#{@options[:origin][:lat]},#{@options[:origin][:lng]}"
      destination_points = "#{@options[:destination][:lat]},#{@options[:destination][:lng]}"
      "origins=#{origin_points}&destinations=#{destination_points}"
    end

    def make_api
      url = "https://maps.googleapis.com/maps/api/distancematrix/json?#{build_params}&key=#{$google_api_key}"
      @map_response = RestClient.get(url)
    rescue Exception => e
      Rails.logger.error("Something went wrong when calling google maps api")
    end

    def parsed_distance
      map_response = JSON.parse(@map_response.body)
      map_response['rows'].first['elements'].first["distance"]["value"]
    rescue Exception => e
      Rails.logger.error("Something went wrong when parsing google maps api #{map_response.inspect}")
      GRACE_DISTANCE + GRACE_DISTANCE
    end
end