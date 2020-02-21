class Admin::PerformanceEvaluationsController < ApplicationController

  def create
    @performance_evaluation = PerformanceEvaluation.new(performance_evaluation_params)
    if @performance_evaluation.save
      render json: @performance_evaluation, status: :created
    else
      render json: @performance_evaluation.errors, status: :unprocessable_entity
    end
  end

  private

  def performance_evaluation_params
    params.permit(:title, :description, :employee_id)
  end
end
