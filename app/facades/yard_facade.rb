class YardFacade
  def self.get_data(yard_id, user_id)
    {
      yard_details: yard_details(yard_id),
      button_params: button_params(user_id)
    }
  end

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

  def self.button_params(user_id)
    if @yard != {}
      if user_id == @yard.host_id
        button_params = {}
        button_params[:text] = "Edit"
        button_params[:path] = "/host/yards/#{@yard.id}/edit"
        button_params[:method] = :get
      else
        button_params = {}
        button_params[:text] = "Rent"
        button_params[:path] = "/bookings/new"
        button_params[:method] = :post
      end
    end
    button_params
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
