class SalariesController < ApplicationController
  before_action :set_salary, only: [:show, :update, :destroy]

  def index
    salaries = Salary.includes(:salary_slab_inputs).all
    render json: salaries.as_json(include: :salary_slab_inputs), status: :ok
  end

  def show
    render json: @salary.as_json(include: :salary_slab_inputs), status: :ok
  end

  def create
    salary = Salary.new(salary_params)
    if salary.save
      render json: salary.as_json(include: :salary_slab_inputs), status: :created
    else
      render json: { errors: salary.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @salary.update(salary_params)
      render json: @salary.as_json(include: :salary_slab_inputs), status: :ok
    else
      render json: { errors: @salary.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @salary.destroy
    head :no_content
  end

  private

  def set_salary
    @salary = Salary.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Salary not found' }, status: :not_found
  end

  def salary_params
    params.require(:salary).permit(
      :salary_id, :carer_id, :group_id, :region_id, :time_period, :customized_checkbox, :account_id,
      salary_slab_inputs_attributes: [:id, :rate, :_destroy]
    )
  end
end
