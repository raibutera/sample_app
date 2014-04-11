class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:edit, :update, :index]
  before_filter :correct_user, only: [:edit, :update]
  before_filter :admin_user, only: [:destroy]
  before_filter :not_logged_in, only: [:new, :create]
  before_filter :stupid_admin, only: [:destroy]
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      # on successful save redirect to user's profile
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def edit
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "Man down. BRRUP."
    redirect_to users_url
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end 
  end

  private

    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in."
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

    def not_logged_in
      redirect_to root_url, :flash => { :error => "User already exists!" } if signed_in?
    end

    def stupid_admin
      redirect_to root_url, :flash => { :error => "WTF" } if User.find(params[:id]).admin
    end
end
