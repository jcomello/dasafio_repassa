class Admin::EmployeesController < Admin::ApplicationController
  before_action :find_employee, only: %i[update destroy show]

  def index
    @employees = current_admin_user.employees
    render json: @employees, status: :ok
  end

  def create
    @employee = current_admin_user.employees.new(employee_params)
    if @employee.save
      render json: @employee, status: :created
    else
      render json: @employee.errors, status: :unprocessable_entity
    end
  end

  def show
    render json: @employee, status: :ok
  end

  def update
    @employee.assign_attributes(employee_params)

    if @employee.save
      render json: @employee, status: :ok
    else
      render json: @employee.reload.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @employee.destroy
  end

  private

  def find_employee
    @employee = current_admin_user.employees.find(params[:id])
  rescue
    render status: :not_found
  end

  def employee_params
    params.permit(:name)
  end
end
