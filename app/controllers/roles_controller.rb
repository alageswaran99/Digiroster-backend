class RolesController < ApplicationController
  # before_action :access_denied
  before_action :set_role, only: [:show]

  # GET /roles
  # GET /roles.json
  decorate_views(decorate_objects: [:specific_roles])
  def index
    @items = scoper.all
  end

  # GET /roles/1
  # GET /roles/1.json
  def show
  end

  def specific_roles
    @items = scoper.where(id: params[:role_ids])
    render :index
  end

  # POST /roles
  # POST /roles.json
  # def create
  #   @role = Role.new(role_params)

  #   if @role.save
  #     render :show, status: :created
  #   else
  #     render json: @role.errors, status: :unprocessable_entity
  #   end
  # end

  # PATCH/PUT /roles/1
  # PATCH/PUT /roles/1.json
  # def update
  #   if @role.update(role_params)
  #     render :show, status: :ok
  #   else
  #     render json: @role.errors, status: :unprocessable_entity
  #   end
  # end

  # DELETE /roles/1
  # DELETE /roles/1.json
  # def destroy
  #   @role.destroy
  # end

  private

    def scoper
      current_account.roles
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_role
      @role = scoper.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      raise CustomErrors::NotFound, 'Invalid Resource ID'
    end

    # # Only allow a list of trusted parameters through.
    # def role_params
    #   params.require(:role).permit(:name, :privileges, :description, :custom_default_role, :account_id)
    # end
end
