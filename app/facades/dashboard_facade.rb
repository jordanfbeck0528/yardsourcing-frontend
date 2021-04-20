class DashboardFacade

  def self.get_data(host_id)
    {
      host_yards: host_yards(host_id),
      host_bookings: host_bookings(host_id)
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
                        purposes:        all_purposes(yard) })
      end
  end

  def self.full_address(yard)
    "#{yard[:attributes][:street_address]} #{yard[:attributes][:city]}, #{yard[:attributes][:state]} #{yard[:attributes][:zipcode]}"
  end

  def self.all_purposes(yard)
    yard[:attributes][:purposes][:data].map do |purpose|
      purpose[:attributes][:name]
    end
  end

  def self.host_bookings(host_id)
    host_yards = EngineService.host_bookings(host_id)
    host_yards[:data].map do |yard|
       OpenStruct.new({ id:          yard[:id],
                        name:        yard[:attributes][:booking_name],
                        status:      yard[:attributes][:status],
                        date:        yard[:attributes][:date],
                        time:        yard[:attributes][:time],
                        duration:    yard[:attributes][:duration],
                        description: yard[:attributes][:description]})
      end
  end
end
