class Admin::EmployeesController < ApplicationController
  def create
    @employee = Employee.new(employee_params)
    if @employee.save
      render json: @employee, status: :created
    else
      render json: @employee.errors, status: :unprocessable_entity
    end
  end

  private

  def employee_params
    params.permit(:name)
  end
end
