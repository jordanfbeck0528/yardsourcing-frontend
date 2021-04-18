class YardsController < ApplicationController

  def show
    yard = EngineService.yard_details(params[:id])
    if yard == {}
      @yard = {}
    elsif
      @yard = OpenStruct.new({  name:        yard[:attributes][:name],
                          host_id:     yard[:attributes][:host_id],
                           id:           yard[:id],
                           description:  yard[:attributes][:description],
                           address:      full_address(yard),
                           price:        yard[:attributes][:price],
                           purposes:     all_purposes(yard) })

      if current_user.id == @yard.host_id
        @button_params = {}
        @button_params[:text] = "Edit"
        @button_params[:path] = host_yards_path(current_user.id)
        @button_params[:method] = :patch
      else
        @button_params = {}
        @button_params[:text] = "Rent"
        @button_params[:path] = "bookings/new"
        @button_params[:method] = :post
      end
    end
  end

  private

  def full_address(yard)
    "#{yard[:attributes][:street_address]}, #{yard[:attributes][:city]}, #{yard[:attributes][:state]}, #{yard[:attributes][:zipcode]}"
  end

  def all_purposes(yard)
    yard[:attributes][:purposes][:data].map do |purpose|
      purpose[:attributes][:name]
    end
  end
end
