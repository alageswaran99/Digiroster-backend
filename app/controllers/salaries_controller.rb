class SalariesController < ApplicationController
  before_action :set_account_id, only: [:show, :update, :destroy]
  before_action :validate_params, only: [:create, :update]

  def index
    salaries = Salary.where(account_id: @account_id).paginate(page: params[:page], per_page: 10)
    render json: salaries, status: :ok
  end

  def current_carer_id
    current_carer = Carer.find_by(account_id: @account_id)

    if current_carer
      render json: { carer_id: current_carer.id }, status: :ok
    else
      render json: { error: 'Current carer not found' }, status: :not_found
    end
  end

  def create
    # Check if salary already exists for the carer and time period
    existing_salary = Salary.find_by(carer_id: params[:carer_id], time_period: params[:time_period], account_id: @account_id)

    if existing_salary
      render json: { error: 'Salary already exists for this period.' }, status: :unprocessable_entity
    else
      salary = Salary.new(salary_params)
      salary.account_id = @account_id

      if salary.save
        render json: { message: 'Salary created successfully', salary: salary }, status: :created
      else
        render json: { errors: salary.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end

  def update
    salary = Salary.find_by!(salary_id: params[:id], account_id: @account_id)

    if salary.update(salary_params)
      render json: { message: 'Salary updated successfully', salary: salary }, status: :ok
    else
      render json: { errors: salary.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    salary = Salary.find_by!(salary_id: params[:id], account_id: @account_id)

    if salary.destroy
      render json: { message: 'Salary deleted successfully' }, status: :ok
    else
      render json: { error: 'Failed to delete salary' }, status: :unprocessable_entity
    end
  end

  private

  # Set the account ID for the current user
  def set_account_id
    @account_id = current_user&.account_id || params[:account_id]
    render json: { error: 'Account ID is required' }, status: :unauthorized unless @account_id
  end

  # Validate required parameters for create and update actions
  def validate_params
    unless params[:salary][:carer_id].present? && params[:salary][:time_period].present?
      render json: { error: 'Carer ID and Time Period are required' }, status: :unprocessable_entity
    end
  end

  # Permit parameters for salary creation and update
  def salary_params
    params.require(:salary).permit(
      :salary_id,
      :carer_id,
      :group_id,
      :region_id,
      :time_period,
      :customized_checkbox,
      salary_slab_inputs_attributes: [:id, :rate]
    )
  end
end
