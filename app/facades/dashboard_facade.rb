class DashboardFacade

  def self.get_data(host_id)
    {
      host_yards: host_yards(host_id),
      host_bookings: host_bookings(host_id)
    }
  end

  def self.get_bookings_by_status(renter_id)
    {
      approved_bookings: renter_bookings_by_status(renter_id, 'approved'),
      pending_bookings: renter_bookings_by_status(renter_id, 'pending')
    }
  end

  def self.host_yards(host_id)
    host_yards = EngineService.host_yards(host_id)
    host_yards[:data].map do |yard|
       OpenStruct.new({ name:         yard[:attributes][:name],
                        id:           yard[:id],
                        description:  yard[:attributes][:description],
                        address:      full_address(yard),
                        price:        yard[:attributes][:price],
                        purposes:     all_purposes(yard),
                        photo_url_1:  yard[:attributes][:photo_url_1] })
      end
  end

  def self.renter_bookings_by_status(renter_id, status)
    renter_bookings = EngineService.renter_bookings_by_status(renter_id, status)
    renter_bookings = renter_bookings[:data].map do |booking|
      booking_struct(booking)
    end
  end

  def self.host_bookings(host_id)
    host_bookings = EngineService.host_bookings(host_id)
    host_bookings[:data].map do |booking|
      booking_struct(booking)
    end
  end

  def self.booking_struct(booking)
    yard_info = yard_info(booking[:attributes][:yard_id])
    OpenStruct.new({ id:         booking[:id],
                     yard_id:    booking[:attributes][:yard_id],
                     yard_name:  yard_info[:attributes][:name],
                     status:     booking[:attributes][:status],
                     name:       booking[:attributes][:booking_name],
                     address:    full_address(yard_info),
                     date:       booking[:attributes][:date].to_date,
                     time:       get_time(booking),
                     duration:   booking[:attributes][:duration],
                     total_cost: total_cost(booking[:attributes][:duration], yard_info[:attributes][:price]),
                     img:        yard_info[:attributes][:photo_url_1] })
  end

  def self.yard_info(yard_id)
    EngineService.yard_details(yard_id)
  end

  def self.full_address(yard)
    "#{yard[:attributes][:street_address]} #{yard[:attributes][:city]}, #{yard[:attributes][:state]} #{yard[:attributes][:zipcode]}"
  end

  def self.all_purposes(yard)
    yard[:attributes][:purposes][:data].map do |purpose|
      purpose[:attributes][:name]
    end
  end

  def self.total_cost(duration, price)
    duration * price
  end

  def self.get_time(booking)
    d = booking[:attributes][:date].to_date
    t = booking[:attributes][:time].to_time
    dt = DateTime.new(d.year, d.month, d.day, t.hour, t.min)
  end
end
