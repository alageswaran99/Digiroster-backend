class CareTaker::Checkin
  def initialize(params, appt)
    @options = HashWithIndifferentAccess.new(params)
    @appt = appt
  end

  def can_checkin?
    return true if @appt.client.map_data.blank?
    
    gmap = GMap.new(build_params)
    gmap.checkin_allowed?
  rescue Exception => e
    Rails.logger.error("Error!!! #{e.inspect}")
    false
  end

  private

    def build_params
      {
        origin: @appt.client.map_data,
        destination: @options[:map_data]
      }
    end
end