class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @items = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # POST /users
  # POST /users.json
  def create
    @item = scoper.new(user_params)

    if @item.save
      render :show, status: :created
    else
      render :show, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    if @item.update(user_params)
      render :show, status: :ok
    else
      render :show, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    raise CustomErrors::Unauthorized, 'Action Not Allowed'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @item = scoper.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      raise CustomErrors::NotFound, 'Invalid Resource ID'
    end

    def scoper
      current_account.users
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.fetch(:user, {})
    end
end
