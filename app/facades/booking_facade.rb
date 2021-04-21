class BookingFacade
  def self.get_booking(booking_id)

    booking = EngineService.booking_details(booking_id)
    if booking == {}
      booking = {}
    else
      yard_info = yard_info(booking[:attributes][:yard_id])
      OpenStruct.new({ id:           booking[:id],
                       yard_id:      booking[:attributes][:yard_id],
                       yard_name:    yard_info[:attributes][:name],
                       status:       booking[:attributes][:status],
                       name:         booking[:attributes][:booking_name],
                       address:      full_address(yard_info),
                       date:         booking[:attributes][:date].to_date,
                       time:         booking[:attributes][:time].to_time,
                       duration:     booking[:attributes][:duration],
                       description:  booking[:attributes][:description],
                       total_cost:   total_cost(booking[:attributes][:duration], yard_info[:attributes][:price])})
    end
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
end
