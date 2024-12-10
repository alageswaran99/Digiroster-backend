class ClientsController < ApplicationController
  before_action :set_client, only: [:show, :update, :destroy, :boarding_docs, :delete_docs]
  before_action :validate_params, only: [:create, :update]

  decorate_views({
    decorate_object: [:boarding_docs]
  })
  # GET /clients
  # GET /clients.json
  def index
    @items = scoper.all
  end

  # GET /clients/1
  # GET /clients/1.json
  def show
  end

  # POST /clients
  # POST /clients.json
  def create
    @item = scoper.new(client_params)
    if @item.save
      render :show, status: :created
    else
      render :show, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /clients/1
  # PATCH/PUT /clients/1.json
  def update
    if @item.update(client_params)
      render :show, status: :ok
    else
      render :show, status: :unprocessable_entity
    end
  end
  
  def boarding_docs
    if @item.update(client_file_params)
      render :show, status: :ok
    else
      render :show, status: :unprocessable_entity
    end
  end

  # DELETE /clients/1
  # DELETE /clients/1.json
  def destroy
    @item.make_inactive
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

    def client_file_params
      params.permit(:general_file)
    end

    def scoper
      current_account.clients
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_client
      @item = scoper.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      raise CustomErrors::NotFound, 'Invalid Resource ID'
    end

    # Only allow a list of trusted parameters through.
    def client_params
      params.require(:client).permit(:email, :mobile, :address, :title, :gender, :first_name, :last_name,
       :middle_name, :dob, :postcode, :keynote, :group_id, :general_file, services: [], region_ids: [], map_data: [:lat, :lng])
    end

    def validate_params
      @client_delegator = ClientDelegator.new(params, {context: @_action_name.to_sym})
      unless @client_delegator.valid?
        render :show, status: :unprocessable_entity
      end
    end
end
