require "uri"
require "net/http"
require 'twilio-ruby'

class Vaccine
  attr_accessor :vaccine_status

  def check_availability
    fetch_dates.each do |x|
      begin
        do_process(x)
      rescue Exception => e
        Rails.logger.info("Error handled for #{x} --- #{e.inspect}")
      end
    end
    @vaccine_status
  end

  def fetch_dates
    (0..6).map{ |n| (Date.today+n).strftime("%d-%m-%Y")}
  end

  def twilio_twilio(given_date)
    @vaccine_status = true
    twilio_send_sms(given_date) rescue Rails.logger.info("Error while sending sms")
    twilio_make_call rescue Rails.logger.info("Error while making call")
  end

  def twilio_send_sms

    # Find your Account SID and Auth Token at twilio.com/console
    # and set the environment variables. See http://twil.io/secure
    account_sid = 'AC375b18954478acdcb0076eb23eb41227'
    auth_token = ENV['TWILIO_AUTH_TOKEN']
    @client = Twilio::REST::Client.new(account_sid, auth_token)

    message = @client.messages.create(
                                body: "Vaccine Available Book Now!! -- #{given_date}",
                                from: '+14438430156',
                                to: '+919629978167'
                              )

    puts message.sid
  end

  def twilio_make_call
    account_sid = 'AC375b18954478acdcb0076eb23eb41227'
    auth_token = ENV['TWILIO_AUTH_TOKEN']

    # set up a client to talk to the Twilio REST API
    @client = Twilio::REST::Client.new(account_sid, auth_token)

    call = @client.calls.create(
        to: "+919629978167",
        from: "+14438430156",
        url: "http://demo.twilio.com/docs/voice.xml")
    puts call.to
  end

  def do_process(given_date)
    #given_date = "10-06-2021"
    url = URI("https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/calendarByDistrict?district_id=539&date=#{given_date}")
    puts "checking for date :: #{given_date}"
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true
    request = Net::HTTP::Get.new(url)

    response = https.request(request)
    body = JSON.parse(response.read_body)["centers"]

    pref_center = body.find { |x| x['center_id'] == 646904 }

    if pref_center.nil?
      puts "Pref center NA"
    else

      pref_center['sessions'].each do |_x|
        next if _x['available_capacity'].zero?

        next if _x['min_age_limit'] > 18

        next if _x['vaccine'] != 'COVAXIN'

        if _x['available_capacity_dose1'].nonzero?
          Rails.logger.info("vaccine available... for #{given_date}")
          twilio_twilio(given_date)
          vaccine_status = true
          return vaccine_status
        end

      end
    end
  end
end

# loop do
#   Vaccine.new.check_availability
#   puts "sleeping..."
#   sleep(30)
# end