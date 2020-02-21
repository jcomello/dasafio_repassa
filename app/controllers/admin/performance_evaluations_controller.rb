class Admin::PerformanceEvaluationsController < ApplicationController
  before_action :find_performance_evaluation, only: :update

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

  private

  def find_performance_evaluation
    @performance_evaluation = PerformanceEvaluation.find(params[:id])
  end

  def performance_evaluation_params
    params.permit(:title, :description, :employee_id)
  end
end
