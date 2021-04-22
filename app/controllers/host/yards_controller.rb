class Host::YardsController < ApplicationController
  before_action :set_purposes, only: [:new, :create, :update, :edit]
  before_action :set_host_params, only: [:create, :update]

  def new
    @yard = YardFacade.yard_object(params)
  end

  def create
    yard = EngineService.create_yard(yard_params)
    if yard.include?(:error)
      @yard = YardFacade.yard_object(params)
      flash[:error] = yard[:error]
      render :new, obj: @purposes
    else
      redirect_to host_yard_path(yard[:data][:id])
    end
  end

  def show
    @yard = YardFacade.yard_details(params[:id])
  end

  def edit
    @yard = YardFacade.yard_details(params[:id])
  end

  def update
    yard = EngineService.update_yard(yard_params)
    @yard = YardFacade.yard_details(params[:id])
      if yard[:error]
        flash[:error] = yard[:error]
        render :edit
      else
      redirect_to yard_path(params[:id])
    end
  end

  def destroy
    yard = EngineService.delete_yard({id: params[:id]})
    if yard[:error]
      flash[:error] = yard[:error]
      redirect_to host_yard_path(params[:id])
    else
      redirect_to host_dashboard_index_path
    end
  end

  private

  def yard_params
    params.permit(:id, :host_id, :email, :name, :description, :availability, :payment,
                  :price, :street_address, :city, :state, :zipcode, :photo_url_1,
                  :photo_url_2, :photo_url_3, purposes: [])
  end

  # def set_purposes
  #   info = EngineService.all_purposes
  #   @purposes = info[:data].map do |obj_info|
  #     OpenStruct.new({ id: obj_info[:id],
  #                      name: obj_info[:attributes][:name].titleize})
  #   end
  # end

  def set_host_params
    params[:host_id] = current_user.id
    params[:email] = current_user.email
  end
end
