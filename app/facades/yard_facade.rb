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
      @yard = to_yard_object(yard)
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

  def self.yards_in_location(yard_params)
    yards = EngineService.yards_in_location(yard_params)
    object = OpenStruct.new({yards: yards})
    return object if yards[:data].nil? || yards[:data].empty?

    object[:yards] = yards[:data].map do |yard|
      to_yard_object(yard)
    end

    object[:coords] = get_coords(object[:yards])
    object
  end

  def self.to_yard_object(yard)
    OpenStruct.new({ name:         yard[:attributes][:name],
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

  def self.get_coords(yards)
    Geokit::Geocoders::MapQuestGeocoder.key = ENV['mapquest_key']
    Geokit::Geocoders::provider_order = [:mapquest]

    yards.reduce([]) do |locations, yard|
      coords = Geokit::Geocoders::MapQuestGeocoder.geocode yard.address
      locations << [coords.lat, coords.lng]
    end
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
    return yard if yard == {}

    OpenStruct.new({ name:           yard[:attributes][:name],
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
