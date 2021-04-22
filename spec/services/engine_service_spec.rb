require 'rails_helper'

RSpec.describe "EngineService", type: :feature do
  describe "::all_purposes" do
    it "should return json response of all purposes" do
      VCR.use_cassette('engine/all_purposes') do
        es = EngineService.all_purposes

        many_purposes_response_evaluation(es)
      end
    end
  end

  describe "::create_yard(yard_params)" do
    it "Creates a yards and a json record is returned" do
      VCR.use_cassette('engine/create_yard') do
        yard_params = { :name=>"name",
                        :email=>"email@email.com",
                        :host_id=>"123545",
                        :description=>"description",
                        :availability=>"availability",
                        :payment=>"payment",
                        :price=>"25.2",
                        :street_address=>"street_address",
                        :city=>"city",
                        :state=>"state",
                        :zipcode=>"zipcode",
                        :photo_url_1=>"https://photo.com/path",
                        :photo_url_2=>"",
                        :photo_url_3=>"",
                        :purposes=>["1", "3"]}

        es = EngineService.create_yard(yard_params)

        yards_details_response_evaluation(es)
      end
    end
  end
  describe "::update_yard(yard_params)" do
    it "Updates a yard and a json record is returned" do
      VCR.use_cassette('engine/update_yard') do
        yard_params = { :name=>"name",
                        :email=>"email@email.com",
                        :host_id=>"123545",
                        :description=>"description",
                        :availability=>"availability",
                        :payment=>"payment",
                        :price=>"25.2",
                        :street_address=>"street_address",
                        :city=>"city",
                        :state=>"state",
                        :zipcode=>"zipcode",
                        :photo_url_1=>"https://photo.com/path",
                        :photo_url_2=>"",
                        :photo_url_3=>"",
                        :purposes=>["1", "3"]}

        es = EngineService.create_yard(yard_params)
        yard_params[:id] = es[:data][:id]
        yard_params[:name] = "A new name!"
        es = EngineService.update_yard(yard_params)

        yard_detail_response_evaluation(es[:data])
      end
    end
  end
  describe "::delete_yard(yard_params)" do
    it "Deletes a yard and a json record is returned" do
      VCR.use_cassette('engine/delete_yard') do
        yard_params = { :name=>"name",
                        :email=>"email@email.com",
                        :host_id=>"123545",
                        :description=>"description",
                        :availability=>"availability",
                        :payment=>"payment",
                        :price=>"25.2",
                        :street_address=>"street_address",
                        :city=>"city",
                        :state=>"state",
                        :zipcode=>"zipcode",
                        :photo_url_1=>"https://photo.com/path",
                        :photo_url_2=>"",
                        :photo_url_3=>"",
                        :purposes=>["1", "3"]}

        es = EngineService.create_yard(yard_params)
        yard_params = { :id=>"#{es[:data][:id]}"}
        es = EngineService.delete_yard(yard_params)

        expect(es).to be_a(Hash)
        expect(es.keys).to eq([ :id,
                                :host_id,
                                :name,
                                :street_address,
                                :city,
                                :state,
                                :zipcode,
                                :price,
                                :description,
                                :availability,
                                :payment,
                                :photo_url_1,
                                :photo_url_2,
                                :photo_url_3,
                                :created_at,
                                :updated_at,
                                :email])
      end
    end
  end

  describe "::create_booking(booking_params)" do
    it "Creates a booking and a json record is returned" do
      VCR.use_cassette('engine/create_booking') do
        booking_params = { :renter_id=>"1",
                        :renter_email=>"renter@renter.com",
                        :yard_id=>"2",
                        :booking_name=>"A new booking!!",
                        :date=>"2021-05-05",
                        :time=>"2021-05-05 12:00:00 -0500",
                        :duration=>"2",
                        :description=>"description"}

        es = EngineService.create_booking(booking_params)

        booking_details_response_evaluation(es)
      end
    end
  end

  describe "::update_booking_status(booking_params)" do
    it "Updates a booking and a json record is returned" do
      VCR.use_cassette('engine/update_booking') do
        booking_params = { id: 100,
                        :renter_id=>"1",
                        :renter_email=>"renter@renter.com",
                        :yard_id=>"2",
                        :booking_name=>"A new booking!!",
                        :date=>"2021-05-05",
                        :time=>"2021-05-05 12:00:00 -0500",
                        :duration=>"2",
                        :description=>"description"}

        es = EngineService.create_booking(booking_params)
        booking_params = { :id=>"#{es[:data][:id]}"}

        es = EngineService.update_booking_status(booking_params)

        booking_details_response_evaluation(es)
      end
    end
  end
  describe "::delete_booking(booking_params)" do
    it "Deletes a booking and a json record is returned" do
      VCR.use_cassette('engine/delete_booking') do
        booking_params = {:renter_id=>"1",
                        :renter_email=>"renter@renter.com",
                        :yard_id=>"2",
                        :booking_name=>"A new booking!!",
                        :date=>"2021-05-05",
                        :time=>"2021-05-05 12:00:00 -0500",
                        :duration=>"2",
                        :description=>"description"}

        es = EngineService.create_booking(booking_params)
        booking_params = { :id=>"#{es[:data][:id]}"}
        es = EngineService.delete_booking(booking_params)

        expect(es).to be_a(Hash)
        expect(es.keys).to eq([ :id,
                                :yard_id,
                                :renter_id,
                                :status,
                                :booking_name,
                                :date,
                                :time,
                                :duration,
                                :description,
                                :created_at,
                                :updated_at,
                                :renter_email])
      end
    end
  end

  describe "::yard_details" do
    it "should return json response of yard details" do
      VCR.use_cassette('engine/yard_details') do
        es = EngineService.yard_details(2)
        yard_detail_response_evaluation(es)
      end
    end
  end

  describe "::host_yards(host_id)" do
    it "should return a list of a host's yards" do
      VCR.use_cassette('engine/host_yards') do
        es = EngineService.host_yards(1)

        many_yards_response_evaluation(es)
      end
    end
  end

  describe "::host_bookings(host_id)" do
    it "should return a list of a host's bookings" do
      VCR.use_cassette 'bookings/host-bookings-service' do
        es = EngineService.host_bookings(1)
        many_host_bookings_response_evaluation(es)
      end
    end
  end

  describe "::renter_bookings_by_status(renter_id, status)" do
    it "should return a list of a bookings by approved status" do
      VCR.use_cassette('engine/approved_bookings') do
        es = EngineService.renter_bookings_by_status(1, 'approved')

        many_bookings_response_evaluation(es)
      end
    end

    it "should return a list of a bookings by pending status" do
      VCR.use_cassette('engine/pending_bookings') do
        es = EngineService.renter_bookings_by_status(1, 'pending')

        many_bookings_response_evaluation(es)
      end
    end
  end

  def many_yards_response_evaluation(es)
    expect(es[:data]).to be_an(Array)
    expect(es[:data].first).to be_a(Hash)
    expect(es[:data].first.keys).to eq([:id, :type, :attributes])
    expect(es[:data].first[:type]).to eq("yard")
    expect(es[:data].first[:attributes].keys).to eq([ :host_id,
                                                :name,
                                                :street_address,
                                                :city,
                                                :state,
                                                :zipcode,
                                                :description,
                                                :availability,
                                                :payment,
                                                :photo_url_1,
                                                :photo_url_2,
                                                :photo_url_3,
                                                :price,
                                                :purposes])
    expect(es[:data].first[:attributes][:purposes][:data]).to be_an(Array)
    expect(es[:data].first[:attributes][:purposes][:data].first.keys).to eq([:id, :type, :attributes])
    expect(es[:data].first[:attributes][:purposes][:data].first[:attributes].keys).to eq([:name])
  end

  def many_host_bookings_response_evaluation(es)
    expect(es[:data]).to be_an(Array)
    expect(es[:data].first).to be_a(Hash)
    expect(es[:data].first.keys).to eq([:id, :type, :attributes])
    expect(es[:data].first[:type]).to eq("booking")
    expect(es[:data].first[:attributes].keys).to eq([:status,
                                                    :yard_id,
                                                    :booking_name,
                                                    :renter_id,
                                                    :date,
                                                    :time,
                                                    :duration,
                                                    :description])
  end

  def yards_details_response_evaluation(es)
    expect(es[:data]).to be_a(Hash)
    expect(es[:data].keys).to eq([:id, :type, :attributes])
    expect(es[:data][:attributes].keys).to eq([ :host_id,
                                                :name,
                                                :street_address,
                                                :city,
                                                :state,
                                                :zipcode,
                                                :description,
                                                :availability,
                                                :payment,
                                                :photo_url_1,
                                                :photo_url_2,
                                                :photo_url_3,
                                                :price,
                                                :purposes])
    expect(es[:data][:attributes][:purposes].keys).to eq([:data])
    expect(es[:data][:attributes][:purposes][:data]).to be_an(Array)
    expect(es[:data][:attributes][:purposes][:data].first).to be_a(Hash)
    expect(es[:data][:attributes][:purposes][:data].first.keys).to eq([:id, :type, :attributes])
    expect(es[:data][:attributes][:purposes][:data].first[:attributes].keys).to eq([:name])
  end

  def yard_detail_response_evaluation(es)
    expect(es).to be_a(Hash)
    expect(es.keys).to eq([:id, :type, :attributes])
    expect(es[:attributes].keys).to eq([ :host_id,
                                          :name,
                                          :street_address,
                                          :city,
                                          :state,
                                          :zipcode,
                                          :description,
                                          :availability,
                                          :payment,
                                          :photo_url_1,
                                          :photo_url_2,
                                          :photo_url_3,
                                          :price,
                                          :purposes
                                          ])
    expect(es[:attributes][:purposes].keys).to eq([:data])
    expect(es[:attributes][:purposes][:data]).to be_an(Array)
    expect(es[:attributes][:purposes][:data].first).to be_a(Hash)
    expect(es[:attributes][:purposes][:data].first.keys).to eq([:id, :type, :attributes])
    expect(es[:attributes][:purposes][:data].first[:attributes].keys).to eq([:name])
  end

  def booking_details_response_evaluation(es)
    expect(es[:data]).to be_a(Hash)
    expect(es[:data].keys).to eq([:id, :type, :attributes])
    expect(es[:data][:attributes].keys).to eq([ :status,
                                                :yard_id,
                                                :booking_name,
                                                :renter_id,
                                                :date,
                                                :time,
                                                :duration,
                                                :description])
  end

  def many_purposes_response_evaluation(es)
    expect(es[:data]).to be_an(Array)
    expect(es[:data].first).to be_a(Hash)
    expect(es[:data].first.keys).to eq([:id, :type, :attributes])
    expect(es[:data].first[:type]).to eq("purpose")
    expect(es[:data].first[:attributes].keys).to eq([:name])
  end

  def many_bookings_response_evaluation(es)
    expect(es[:data]).to be_an(Array)
    expect(es[:data].first).to be_a(Hash)
    expect(es[:data].first.keys).to eq([:id, :type, :attributes])
    expect(es[:data].first[:type]).to eq("booking")
    expect(es[:data].first[:attributes].keys).to eq([ :status,
                                                      :yard_id,
                                                      :booking_name,
                                                      :renter_id,
                                                      :date,
                                                      :time,
                                                      :duration,
                                                      :description])
  end
end
