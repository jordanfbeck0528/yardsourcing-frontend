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
    if yards[:data].nil? || yards[:data].empty?
      @yards = yards
    else
      @yards = yards[:data].map do |yard|
        yard_object(yard)
      end
    end
    @yards
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
