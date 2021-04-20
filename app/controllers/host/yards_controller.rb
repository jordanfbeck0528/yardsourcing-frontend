# require "services/y_s_engine_service"
class Host::YardsController < ApplicationController
  before_action :set_purposes, only: [:new, :create]

  def new
    @purposes = set_purposes
  end

  def create
    params[:host_id] = current_user.id
    params[:email] = current_user.email
    yard = EngineService.create_yard(yard_params)
    if yard.include?(:error)
      flash[:error] = yard[:error]
      render :new, obj: @purposes
    else
      redirect_to yard_path(yard[:data][:id])
    end
  end


  def update
    if params[:_method] == "patch"
      params[:host_id] = current_user.id
      params[:email] = current_user.email
      params[:id] = params[:id]
      yard = EngineService.update_yard(yard_params)
      redirect_to yard_path(params[:id])
    else
      @purposes = set_purposes
      @yard = yard_details(params[:yard_id])
    end
  end

  private
  def yard_params
    params.permit( :id, :host_id, :email, :name, :description, :availability, :payment,
                  :price, :street_address, :city, :state, :zipcode, :photo_url_1,
                  :photo_url_2, :photo_url_3, purposes: [])
  end

  def set_purposes
    info = EngineService.all_purposes
    info[:data].map do |obj_info|
      OpenStruct.new({ id: obj_info[:id],
                       name: obj_info[:attributes][:name].titleize})
    end
  end

  def yard_details(yard_id)
    yard = EngineService.yard_details(yard_id)
    if yard == {}
      {}
    else
      OpenStruct.new({          name:           yard[:attributes][:name],
                                host_id:        current_user.id,
                                email:          current_user.email,
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
  def all_purposes(yard)
    yard[:attributes][:purposes][:data].map do |purpose|
      purpose[:attributes][:name]
    end
  end
end
