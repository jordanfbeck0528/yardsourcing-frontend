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
    params[:host_id] = current_user.id
    yard = EngineService.create_yard(yard_params)

    redirect_to yard_path(yard[:id])
  end

  private

  def yard_params
    params.permit(:host_id, :name, :description, :availability, :payment,
                  :price, :street_address, :city, :state, :zipcode, :photo_url_1,
                  :photo_url_2, :photo_url_3, purposes: [])
  end
end
