class AgentsController < ApplicationController
  before_action :validate_params, only: [:create, :update]
  before_action :set_agent, only: [:show, :update, :destroy, :change_password, :boarding_docs, :delete_docs]

  # GET /agents
  # GET /agents.json
  decorate_views({
    decorate_object: [:change_password, :boarding_docs]
  })
  def index
    @items = scoper.all
  end

  # GET /agents/1
  # GET /agents/1.json
  def show
  end

  # POST /agents
  # POST /agents.json
  def create
    @item = scoper.new(agent_params)
    if @item.save
      render :show, status: :created
    else
      render :show, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /agents/1
  # PATCH/PUT /agents/1.json
  def update
    if @item.update(agent_params)
      render :show, status: :ok
    else
      render :show, status: :unprocessable_entity
    end
  end

  # DELETE /agents/1
  # DELETE /agents/1.json
  def destroy
    @item.make_inactive
  end

  def change_password
    if check_old_passsword && @item.update(agent_password_change_params)
      render :show, status: :ok
    else
      render :show, status: :unprocessable_entity
    end
  end

  def boarding_docs
    if @item.update(agent_file_params)
      render :show, status: :ok
    else
      render :show, status: :unprocessable_entity
    end
  end

  def delete_docs
    if @item.general_file.attached?
      @item.general_file.purge_later
      head 200
    elsif !@item.general_file.attached?
      head 404
    else
      head 500
    end
  end

  private

    def check_old_passsword
      return true if @item.valid_password?(params[:agent][:old_password])

      @item.errors.add(:password, "Invalid Old Password")
      false
    end

    def scoper
      current_account.agents
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_agent
      @item = scoper.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      raise CustomErrors::NotFound, 'Invalid Resource ID'
    end

    # Only allow a list of trusted parameters through.
    def agent_params
      params.require(:agent).permit(:email, :mobile, :address, :title, :gender, :first_name, :last_name,
       :middle_name, :dob, :postcode, :group_id, :general_file, region_ids: [], role_ids: [], map_data: [:lat, :lng])
    end

    def agent_file_params
      params.permit(:general_file)
    end

    def agent_password_change_params
      params.require(:agent).permit(:password, :password_confirmation)
    end

    def validate_params
      @agent_delegator = AgentDelegator.new(params, {context: @_action_name.to_sym})
      unless @agent_delegator.valid?
        render :show, status: :unprocessable_entity
      end
    end
end
