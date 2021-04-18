class Host::DashboardController < ApplicationController
  def index
    host_yards = EngineService.host_yards(current_user.id)
    @host_yards = host_yards[:data].map do |yard|
       OpenStruct.new({ name:         yard[:attributes][:name],
                        id:           yard[:id],
                        description:  yard[:attributes][:description],
                        address:      full_address(yard),
                        price:        yard[:attributes][:price],
                        purposes:        all_purposes(yard) })
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
