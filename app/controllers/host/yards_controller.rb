# require "services/y_s_engine_service"
class Host::YardsController < ApplicationController
  def new
    info = EngineService.all_purposes

    @purposes = info[:data].map do |obj_info|
      OpenStruct.new({ id: obj_info[:id],
                       name: obj_info[:attributes][:name].titleize})
    end
  end

  def create
    params[:host_id] = current_user.id
    params[:email] = current_user.email

    yard = EngineService.create_yard(yard_params)

    redirect_to yard_path(yard[:id])
  end

  def update
    binding.pry
  end

  private

  def yard_params
    params.permit(:host_id, :email, :name, :description, :availability, :payment,
                  :price, :street_address, :city, :state, :zipcode, :photo_url_1,
                  :photo_url_2, :photo_url_3, purposes: [])
  end
end
