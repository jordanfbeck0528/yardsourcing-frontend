# require "services/y_s_engine_service"
class Host::YardsController < ApplicationController
  def new
    info = EngineService.all_purposes

    @purposes = info[:data].reduce([]) do |array, obj_info|
      array << OpenStruct.new(obj_info)
      array
    end
  end

  def create
    yard_params = {
                    name: params[:name],
                    description: params[:description],
                    availability: params[:availability],
                    payment: params[:payment],
                    price: params[:price],
                    street_address: params[:street_address],
                    city: params[:city],
                    state: params[:state],
                    zipcode: params[:zipcode],
                    photo_url_1: params[:photo_url_1],
                    photo_url_2: params[:photo_url_2],
                    photo_url_3: params[:photo_url_3],
                    purposes: params[:purposes]
                  }

    EngineService.create_yard(yard_params)

    redirect_to host_dashboard_index_path
  end
end
