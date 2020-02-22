class Admin::PerformanceEvaluationsController < Admin::ApplicationController
  before_action :find_performance_evaluation, only: %i[update destroy show]

  def index
    @performance_evaluations = current_admin_user.performance_evaluations
    render json: @performance_evaluations, status: :ok
  end

  def create
    @performance_evaluation = PerformanceEvaluation.new(performance_evaluation_params)
    if @performance_evaluation.save
      render json: @performance_evaluation, status: :created
    else
      render json: @performance_evaluation.errors, status: :unprocessable_entity
    end
  end

  def update
    @performance_evaluation.assign_attributes(performance_evaluation_params)

    if @performance_evaluation.save
      render json: @performance_evaluation, status: :ok
    else
      render json: @performance_evaluation.reload.errors, status: :unprocessable_entity
    end
  end

  def show
    render json: @performance_evaluation, status: :ok
  end

  def destroy
    @performance_evaluation.destroy
  end

  private

  def find_performance_evaluation
    @performance_evaluation = current_admin_user.performance_evaluations.find(params[:id])
  rescue
    return render status: :not_found
  end

  def performance_evaluation_params
    params.permit(:title, :description, :employee_id).merge(current_admin_user: current_admin_user)
  end
end
