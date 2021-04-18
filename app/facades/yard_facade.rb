class YardFacade
  def self.yard_details(yard_id)
    yard = EngineService.yard_details(yard_id)[:data]
    yard = OpenStruct.new({ name:         yard[:attributes][:name],
                            id:           yard[:id],
                            description:  yard[:attributes][:description],
                            availability: yard[:attributes][:availability],
                            address:      full_address(yard),
                            price:        yard[:attributes][:price],
                            purposes:        all_purposes(yard),
                            payment:      yard[:attributes][:payment],
                            photo_url_1:  yard[:attributes][:photo_url_1],
                            photo_url_2:  yard[:attributes][:photo_url_2],
                            photo_url_3:  yard[:attributes][:photo_url_3]})
  end

  def self.full_address(yard)
    "#{yard[:attributes][:street_address]} #{yard[:attributes][:city]}, #{yard[:attributes][:state]} #{yard[:attributes][:zipcode]}"
  end

  def self.all_purposes(yard)
    yard[:attributes][:purposes][:data].map do |purpose|
      purpose[:attributes][:name]
    end
  end
end
