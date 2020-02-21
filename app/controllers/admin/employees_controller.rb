class Admin::EmployeesController < ApplicationController
  before_action :find_employee, only: :update

  def create
    @employee = Employee.new(employee_params)
    if @employee.save
      render json: @employee, status: :created
    else
      render json: @employee.errors, status: :unprocessable_entity
    end
  end

  def update
    @employee.assign_attributes(employee_params)

    if @employee.save
      render json: @employee, status: :ok
    else
      render json: @employee.reload.errors, status: :unprocessable_entity
    end
  end

  private

  def find_employee
    @employee = Employee.find(params[:id])
  end

  def employee_params
    params.permit(:name)
  end
end
