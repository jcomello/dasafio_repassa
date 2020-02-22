class Employee::PerformanceEvaluationsController < Employee::ApplicationController
  def index
    @performance_evaluations = current_employee.performance_evaluations
    render json: @performance_evaluations, status: :ok
  end
end
