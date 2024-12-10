class RegionsController < ApplicationController
  before_action :set_region, only: [:show, :update, :destroy]
  before_action :validate_params, only: [:create, :update]

  decorate_views
  # GET /regions
  # GET /regions.json
  def index
    @items = scoper.all
  end

  # GET /regions/1
  # GET /regions/1.json
  def show
  end

  # POST /regions
  # POST /regions.json
  def create
    @item = scoper.new(region_params)

    if @item.save
      render :show, status: :created
    else
      render :show, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /regions/1
  # PATCH/PUT /regions/1.json
  def update
    if @item.update(region_params)
      render :show, status: :ok
    else
      render :show, status: :unprocessable_entity
    end
  end

  # DELETE /regions/1
  # DELETE /regions/1.json
  def destroy
    raise CustomErrors::Unauthorized, 'Action Not Allowed'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_region
      @item = scoper.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      raise CustomErrors::NotFound, 'Invalid Resource ID'
    end

    def scoper
      current_account.regions
    end

    # Only allow a list of trusted parameters through.
    def region_params
      params.require(:region).permit(:name, :address, :email, :phone)
    end

    def validate_params
      @region_delegator = RegionDelegator.new(params, {context: @_action_name.to_sym})
      unless @region_delegator.valid?
        render :show, status: :unprocessable_entity
      end
    end
end
