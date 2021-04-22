class BookingFacade
  def self.get_booking(booking_id)
    booking = EngineService.booking_details(booking_id)
    return booking if booking == {}

    yard_info = yard_info(booking[:attributes][:yard_id])
    OpenStruct.new({ id:           booking[:id],
                     yard_id:      booking[:attributes][:yard_id],
                     yard_name:    yard_info[:attributes][:name],
                     status:       booking[:attributes][:status],
                     name:         booking[:attributes][:booking_name],
                     address:      full_address(yard_info),
                     date:         booking[:attributes][:date].to_date,
                     time:         get_time(booking),
                     duration:     booking[:attributes][:duration],
                     description:  booking[:attributes][:description],
                     total_cost:   total_cost(booking[:attributes][:duration], yard_info[:attributes][:price]),
                     coords:       get_coords(full_address(yard_info)) })
  end

  def self.full_address(booking)
    "#{booking[:attributes][:street_address]} #{booking[:attributes][:city]}, #{booking[:attributes][:state]} #{booking[:attributes][:zipcode]}"
  end

  def self.total_cost(duration, price)
    duration * price
  end

  def self.yard_info(yard_id)
    EngineService.yard_details(yard_id)
  end

  def self.get_time(booking)
    d = booking[:attributes][:date].to_date
    t = booking[:attributes][:time].to_time
    dt = DateTime.new(d.year, d.month, d.day, t.hour, t.min)
  end

  def self.get_coords(full_address)
    Geokit::Geocoders::MapQuestGeocoder.key = ENV['mapquest_key']
    Geokit::Geocoders::provider_order = [:mapquest]
    Geokit::Geocoders::MapQuestGeocoder.geocode full_address
  end
end
