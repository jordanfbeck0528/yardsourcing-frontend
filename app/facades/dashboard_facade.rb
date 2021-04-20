class DashboardFacade
  def self.get_bookings_by_status(renter_id)
    {
      approved_bookings: renter_bookings_by_status(renter_id, 'approved'),
      pending_bookings: renter_bookings_by_status(renter_id, 'pending')
    }
  end

  def self.host_yards(host_id)
    host_yards = EngineService.host_yards(host_id)
    host_yards = host_yards[:data].map do |yard|
       OpenStruct.new({ name:         yard[:attributes][:name],
                        id:           yard[:id],
                        description:  yard[:attributes][:description],
                        address:      full_address(yard),
                        price:        yard[:attributes][:price],
                        purposes:        all_purposes(yard) })
      end
  end

  def self.renter_bookings_by_status(renter_id, status)
    renter_yards = EngineService.renter_bookings_by_status(renter_id, status)
    renter_yards = renter_yards[:data].map do |yard|
      yard_info = yard_info(yard[:attributes][:yard_id])
      OpenStruct.new({ yard_id:    yard[:attributes][:yard_id],
                       name:       yard[:attributes][:booking_name],
                       address:    full_address(yard_info),
                       date:       yard[:attributes][:date].to_date,
                       duration:   yard[:attributes][:duration],
                       total_cost: total_cost(yard[:attributes][:duration], yard_info[:attributes][:price]),
                       img:        yard_info[:attributes][:photo_url_1] })
    end
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
end
