class Admin::AdminUsersController < Admin::ApplicationController
  skip_before_action :authenticate

  def create
    @admin_user = AdminUser.new(admin_user_params)
    if @admin_user.save
      render json: @admin_user, status: :created
    else
      render json: @admin_user.errors, status: :unprocessable_entity
    end
  end

  private

  def admin_user_params
    params.permit(:name)
  end
end
