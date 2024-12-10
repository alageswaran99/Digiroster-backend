class FeedbacksController < ApplicationController
  before_action :set_feedback, only: %i[ show update destroy ]
  # before_action :validate_params, only: [:create, :update]
  decorate_views
  # GET /feedbacks
  # GET /feedbacks.json
  def index
    if params[:filter].present?
      @items = scoper
      handle_filter
    else
      @items = scoper.all
    end
  end

  # GET /feedbacks/1
  # GET /feedbacks/1.json
  def show
  end

  # POST /feedbacks
  # POST /feedbacks.json
  def create
    @item = scoper.new(feedback_params)

    if @item.save
      render :show, status: :created
    else
      render json: @item.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /feedbacks/1
  # PATCH/PUT /feedbacks/1.json
  def update
    if @item.update(feedback_params)
      render :show, status: :ok
    else
      render json: @item.errors, status: :unprocessable_entity
    end
  end

  # DELETE /feedbacks/1
  # DELETE /feedbacks/1.json
  def destroy
    raise CustomErrors::Unauthorized, 'Action Not Allowed'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_feedback
      @item = scoper.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      raise CustomErrors::NotFound, 'Invalid Resource ID'
    end

    def scoper
      @items = current_account.feedbacks.includes([:agent, :client])
    end

    # Only allow a list of trusted parameters through.
    def feedback_params
      params.require(:feedback).permit(:client_id, :agent_id, :account_id, :other_info, :description, :appointment_id, :note_type, services: [])
    end

    def validate_params
      @feedback_delegator = FeedbackDelegator.new(params, {context: @_action_name.to_sym})
      unless @feedback_delegator.valid?
        render :show, status: :unprocessable_entity
      end
    end

    def handle_filter
      params[:filter].each do |key, value|
        @items = @items.safe_send(key, value)
      end
    end
end
