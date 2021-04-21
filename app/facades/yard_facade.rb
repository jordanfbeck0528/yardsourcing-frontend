class YardFacade

  def self.yard_details(yard_id)
    yard = EngineService.yard_details(yard_id)
    if yard == {}
      @yard = {}
    else
      @yard = yard_object(yard)
    end
  end

  def self.full_address(yard)
    "#{yard[:street_address]} #{yard[:city]}, #{yard[:state]} #{yard[:zipcode]}"
  end

  def self.all_purposes(yard)
    if yard[:purposes].class == Hash
      yard[:purposes][:data].map do |purpose|
        purpose[:attributes][:name]
      end
    end
  end

  def self.yards_in_location(yard_params)
    yards = EngineService.yards_in_location(yard_params)
    object = OpenStruct.new({yards: yards})
    return object if yards[:data].nil? || yards[:data].empty?

    object[:yards] = yards[:data].map do |yard|
      yard_object(yard)
    end

    object[:coords] = get_coords(object[:yards])
    object
  end

  # def self.to_yard_object(yard)
  #   OpenStruct.new({ name:         yard[:attributes][:name],
  #                    host_id:      yard[:attributes][:host_id],
  #                    email:        yard[:attributes][:email],
  #                    id:           yard[:id],
  #                    description:  yard[:attributes][:description],
  #                    availability: yard[:attributes][:availability],
  #                    address:      full_address(yard),
  #                    price:        yard[:attributes][:price],
  #                    purposes:     all_purposes(yard),
  #                    payment:      yard[:attributes][:payment],
  #                    photo_url_1:  yard[:attributes][:photo_url_1],
  #                    photo_url_2:  yard[:attributes][:photo_url_2],
  #                    photo_url_3:  yard[:attributes][:photo_url_3] })
  # end

  def self.get_coords(yards)
    Geokit::Geocoders::MapQuestGeocoder.key = ENV['mapquest_key']
    Geokit::Geocoders::provider_order = [:mapquest]

    yards.reduce([]) do |locations, yard|
      coords = Geokit::Geocoders::MapQuestGeocoder.geocode yard.address
      locations << [coords.lat, coords.lng]
    end
  end

  def self.yard_object(yard)
    id = yard[:id] if yard[:id]
    yard = yard[:attributes] ? yard[:attributes] : yard
    OpenStruct.new({  id:             id,
                      name:           yard[:name],
                      host_id:        yard[:host_id],
                      email:          yard[:email],
                      description:    yard[:description],
                      availability:   yard[:availability],
                      address:        full_address(yard),
                      street_address: yard[:street_address],
                      city:           yard[:city],
                      state:          yard[:state],
                      zipcode:        yard[:zipcode],
                      price:          yard[:price],
                      purposes:       all_purposes(yard),
                      payment:        yard[:payment],
                      photo_url_1:    yard[:photo_url_1],
                      photo_url_2:    yard[:photo_url_2],
                      photo_url_3:    yard[:photo_url_3] })
  end
end
