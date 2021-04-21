class YardFacade

  def self.yard_details(yard_id)
    yard = EngineService.yard_details(yard_id)
    if yard == {}
      @yard = {}
    else
      @yard = OpenStruct.new({  name:         yard[:attributes][:name],
                                host_id:      yard[:attributes][:host_id],
                                email:        yard[:attributes][:email],
                                id:           yard[:id],
                                description:  yard[:attributes][:description],
                                availability: yard[:attributes][:availability],
                                address:      full_address(yard),
                                price:        yard[:attributes][:price],
                                purposes:     all_purposes(yard),
                                payment:      yard[:attributes][:payment],
                                photo_url_1:  yard[:attributes][:photo_url_1],
                                photo_url_2:  yard[:attributes][:photo_url_2],
                                photo_url_3:  yard[:attributes][:photo_url_3] })
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

  def self.yards_in_location(yard_params)
    yards = EngineService.yards_in_location(yard_params)
    if yards[:data].nil? || yards[:data].empty?
      @yards = yards
    else
      @yards = yards[:data].map do |yard|
      OpenStruct.new({          name:         yard[:attributes][:name],
                                host_id:      yard[:attributes][:host_id],
                                email:        yard[:attributes][:email],
                                id:           yard[:id],
                                description:  yard[:attributes][:description],
                                availability: yard[:attributes][:availability],
                                address:      full_address(yard),
                                price:        yard[:attributes][:price],
                                purposes:     all_purposes(yard),
                                payment:      yard[:attributes][:payment],
                                photo_url_1:  yard[:attributes][:photo_url_1],
                                photo_url_2:  yard[:attributes][:photo_url_2],
                                photo_url_3:  yard[:attributes][:photo_url_3] })
      end
    end
    @yards
  end

  def self.yard_object(params)
    OpenStruct.new({  name:           params[:name],
                      host_id:        params[:host_id],
                      email:          params[:email],
                      description:    params[:description],
                      availability:   params[:availability],
                      street_address: params[:street_address],
                      city:           params[:city],
                      state:          params[:state],
                      zipcode:        params[:zipcode],
                      price:          params[:price],
                      payment:        params[:payment],
                      photo_url_1:    params[:photo_url_1],
                      photo_url_2:    params[:photo_url_2],
                      photo_url_3:    params[:photo_url_3] })
  end

  def self.yard_form_info(yard_id)
    yard = EngineService.yard_details(yard_id)
    if yard == {}
      {}
    else
      OpenStruct.new({          name:           yard[:attributes][:name],
                                host_id:        yard[:attributes][:host_id],
                                email:          yard[:attributes][:email],
                                id:             yard[:id],
                                description:    yard[:attributes][:description],
                                availability:   yard[:attributes][:availability],
                                street_address: yard[:attributes][:street_address],
                                city:           yard[:attributes][:city],
                                state:          yard[:attributes][:state],
                                zipcode:        yard[:attributes][:zipcode],
                                price:          yard[:attributes][:price],
                                purposes:       all_purposes(yard),
                                payment:        yard[:attributes][:payment],
                                photo_url_1:    yard[:attributes][:photo_url_1],
                                photo_url_2:    yard[:attributes][:photo_url_2],
                                photo_url_3:    yard[:attributes][:photo_url_3] })
    end
  end
end
