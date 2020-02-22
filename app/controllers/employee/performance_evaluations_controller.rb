class Employee::PerformanceEvaluationsController < Employee::ApplicationController
  before_action :find_performance_evaluation, only: :show

  def index
    @performance_evaluations = current_employee.performance_evaluations
    render json: @performance_evaluations, status: :ok
  end

  def show
    render json: @performance_evaluation, status: :ok
  end

  private

  def find_performance_evaluation
    @performance_evaluation = current_employee.performance_evaluations.find(params[:id])
  rescue
    return render status: :not_found
  end
end
