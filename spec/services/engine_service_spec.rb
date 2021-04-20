require 'rails_helper'

RSpec.describe "EngineService", type: :feature do
  describe "::all_purposes" do
    it "should return json response of all purposes" do
      response = File.open("spec/fixtures/all_purposes.json")
      stub_request(:get, "#{ENV['ys_engine_url']}/api/v1/purposes").
         with(
           headers: {
       	  'Accept'=>'*/*',
       	  'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	  'User-Agent'=>'Faraday v1.3.0'
          }).
        to_return(status: 200, body: response, headers: {})

      es = EngineService.all_purposes

      many_purposes_response_evaluation(es)
    end
  end

  describe "::create_yard(yard_params)" do
    it "Creates a yards and a json record is returned" do
      VCR.use_cassette "create_yard_service" do
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

  describe "::create_booking(booking_params)" do
    it "Creates a booking and a json record is returned" do
      VCR.use_cassette "create-booking-service" do
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

  describe "::yard_details" do
    it "should return json response of all purposes" do
      response = File.open("spec/fixtures/yard_details.json")
      stub_request(:get, "#{ENV['ys_engine_url']}/api/v1/yards/1").
         with(
           headers: {
       	  'Accept'=>'*/*',
       	  'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	  'User-Agent'=>'Faraday v1.3.0'
           }).
         to_return(status: 200, body: response, headers: {})
       es = EngineService.yard_details(1)

       expect(es).to be_a(Hash)
       expect(es.keys).to eq([:id, :type, :attributes])
       expect(es[:attributes].keys).to eq([ :host_id,
                                                   :email,
                                                   :name,
                                                   :street_address,
                                                   :city,
                                                   :state,
                                                   :zipcode,
                                                   :price,
                                                   :description,
                                                   :payment,
                                                   :availability,
                                                   :photo_url_1,
                                                   :photo_url_2,
                                                   :photo_url_3,
                                                   :purposes])
       expect(es[:attributes][:purposes].keys).to eq([:data])
       expect(es[:attributes][:purposes][:data]).to be_an(Array)
       expect(es[:attributes][:purposes][:data].first).to be_a(Hash)
       expect(es[:attributes][:purposes][:data].first.keys).to eq([:id, :type, :attributes])
       expect(es[:attributes][:purposes][:data].first[:attributes].keys).to eq([:name])

    end
  end

  describe "::host_yards(host_id)" do
    it "should return a list of a host's yards" do

      response = File.open("spec/fixtures/host_yards.json")
      stub_request(:get, "#{ENV['ys_engine_url']}/api/v1/hosts/1/yards").
         with(
           headers: {
       	  'Accept'=>'*/*',
       	  'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	  'User-Agent'=>'Faraday v1.3.0'
           }).
         to_return(status: 200, body: response, headers: {})

        es = EngineService.host_yards(1)


      many_yards_response_evaluation(es)
    end
  end

  def many_yards_response_evaluation(es)
    expect(es[:data]).to be_an(Array)
    expect(es[:data].first).to be_a(Hash)
    expect(es[:data].first.keys).to eq([:id, :type, :attributes])
    expect(es[:data].first[:type]).to eq("yard")
    expect(es[:data].first[:attributes].keys).to eq([ :host_id,
                                                :email,
                                                :name,
                                                :street_address,
                                                :city,
                                                :state,
                                                :zipcode,
                                                :price,
                                                :description,
                                                :payment,
                                                :availability,
                                                :photo_url_1,
                                                :photo_url_2,
                                                :photo_url_3,
                                                :purposes])
    expect(es[:data].first[:attributes][:purposes][:data]).to be_an(Array)
    expect(es[:data].first[:attributes][:purposes][:data].first.keys).to eq([:id, :type, :attributes])
    expect(es[:data].first[:attributes][:purposes][:data].first[:attributes].keys).to eq([:name])
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
end
