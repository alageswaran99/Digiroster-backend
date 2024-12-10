class GroupsController < ApplicationController
  before_action :set_group, only: %i[ show update destroy ]
  before_action :validate_params, only: %i[ index update create ]
  # GET /groups
  # GET /groups.json
  decorate_views
  def index
    if params[:filter].present?
      @items = scoper
      handle_filter
    else
      @items = scoper.all
    end
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
  end

  # POST /groups
  # POST /groups.json
  def create
    @item = scoper.new(group_params)

    if @item.save
      render :show, status: :created
    else
      render json: @item.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update
    if @item.update(group_params)
      render :show, status: :ok
    else
      render json: @item.errors, status: :unprocessable_entity
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @item.destroy
  end

  private
    def scoper
      current_account.groups
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @item = scoper.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def group_params
      params.require(:group).permit(:name, :description, :group_type)
    end

    def validate_params
      @group_delegator = GroupDelegator.new(params, {context: @_action_name.to_sym})
      unless @group_delegator.valid?
        render :show, status: :unprocessable_entity
      end
    end

    def handle_filter
      params[:filter].each do |key, value|
        @items = @items.safe_send(key, value)
      end
    end
end
