class EmployeesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user_and_authorized, except: :index
  after_action :verify_authorized
  after_action :verify_policy_scoped, only: :index

  def index
    authorize User

    users = policy_scope(User)
    respond_to do |format|
      format.html
      format.json { render json: UserDatatable.new(params, users: users, view_context: view_context) }
    end
  end

  def show
  end

  def sign_in_histories
    render :show
  end

  def edit
    @user.profile || @user.build_profile
    need_append_application_ids = DoorkeeperApplication.pluck(:id) - @user.user_allowed_applications.pluck(:oauth_application_id)
    need_append_application_ids.each do |application_id|
      @user.user_allowed_applications.build(oauth_application_id: application_id, enable: false)
    end
  end

  def update
    if @user.update(user_params)
      redirect_to employees_path, notice: I18n.t('ui.update_success')
    else
      render 'edit'
    end
  end

  private

  def set_user_and_authorized
    @user = User.find(params[:id])
    authorize @user
  end

  def user_params
    params.require(:user).permit(profile_attributes: [:id, :title], user_allowed_applications_attributes: [:id, :enable, :oauth_application_id])
  end
end
