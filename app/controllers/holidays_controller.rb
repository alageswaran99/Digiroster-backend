class HolidaysController < ApplicationController
  
  before_action :validate_params, only: [:create, :update]
  before_action :set_holiday, only: %i[ show update destroy ]

  decorate_views
  # GET /holidays
  # GET /holidays.json
  def index
    @items = scoper.all
  end

  # GET /holidays/1
  # GET /holidays/1.json
  def show
  end

  # POST /holidays
  # POST /holidays.json
  def create
    @item = scoper.new(holiday_params)

    if @item.save
      render :show, status: :created
    else
      render :show, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /holidays/1
  # PATCH/PUT /holidays/1.json
  def update
    if @item.update(holiday_params)
      render :show, status: :ok
    else
      render :show, status: :unprocessable_entity
    end
  end

  # DELETE /holidays/1
  # DELETE /holidays/1.json
  def destroy
    raise CustomErrors::Unauthorized, 'Action Not Allowed'
    # @item.destroy
  end

  private

    def scoper
      if current_agent.carer?
        current_agent.holidays
      else
        current_account.holidays.includes([:agent])
      end
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_holiday
      @item = scoper.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def holiday_params
      params.require(:holiday).permit(:reason, :from_time, :to_time)
    end

    def validate_params
      @holiday_delegator = HolidayDelegator.new(params, {context: @_action_name.to_sym})
      unless @holiday_delegator.valid?
        render :show, status: :unprocessable_entity
      end
    end
end
