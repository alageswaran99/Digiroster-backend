class SalariesController < ApplicationController
  before_action :set_account_id

  def index
    salaries = Salary.where(account_id: @account_id)
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
    # Prevent duplicate salaries for the same time period and carer
    existing_salary = Salary.find_by(carer_id: params[:carer_id], time_period: params[:time_period], account_id: @account_id)

    if existing_salary
      render json: { error: 'Salary already generated for this time period. You can edit the existing salary.' }, status: :unprocessable_entity
    else
      salary = Salary.new(salary_params)
      salary.account_id = @account_id # Set account_id internally

      if salary.save
        render json: { message: 'Salary created successfully', salary: salary }, status: :created
      else
        render json: { errors: salary.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end

  def update
    salary = Salary.find_by(salary_id: params[:id], account_id: @account_id)

    if salary&.update(salary_params)
      render json: { message: 'Salary updated successfully', salary: salary }, status: :ok
    else
      render json: { error: 'Failed to update salary' }, status: :unprocessable_entity
    end
  end

  def destroy
    salary = Salary.find_by(salary_id: params[:id], account_id: @account_id)

    if salary&.destroy
      render json: { message: 'Salary deleted successfully' }, status: :ok
    else
      render json: { error: 'Failed to delete salary' }, status: :unprocessable_entity
    end
  end

  private

  def set_account_id
    @account_id = 1 # Replace with logic to determine the correct account_id, e.g., current_user.account_id
  end

  def salary_params
    params.require(:salary).permit(
      :salary_id,
      :carer_id,
      :group_id,
      :region_id,
      :time_period,
      :customized_checkbox,
      salary_slab_inputs: [:id, :rate]
    )
  end
end
