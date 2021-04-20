class SearchController < ApplicationController

  def index
    info = EngineService.all_purposes
    @purposes = info[:data].map do |obj_info|
      OpenStruct.new({ id: obj_info[:id],
                       name: obj_info[:attributes][:name].titleize})
    end 
  end
end
