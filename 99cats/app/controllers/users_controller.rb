class UsersController < ApplicationController
  before_action :login_filter, only: [:new, :create]
  before_action :require_login, only: :show

  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      login!(@user)
      flash[:notice] = "Thanks for signing up #{@user.user_name}"
      redirect_to cats_url
    else
      render :new
    end
  end

  def show

    render :show
  end
end
