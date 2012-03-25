require 'bcrypt'

class UsersController < ApplicationController
	before_filter :require_admin, :only => [:index, :destroy]
	before_filter :require_user, :only => [:edit, :update]
	before_filter :require_guest, :only => [:forget, :sent, :recovery, :password_changed]

  def index
    @users = User.all
  
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end
  
  def edit
    @user = current_user
  end

  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end
  
  def forget # I forget a password;
             # Here users puts an email. If okay, they redirected to sent
    @title = "Password recovery"
  end
  
  def sent
    identity = Identity.find_by_email(params[:email])
    if identity
      respond_to do |format|
        PasswordRecovery.password_recovery(identity.id).deliver
        format.html { redirect_to(root_path, :notice => 'We sent password recovery email to ' + identity.email) }
      end
    else
      @title = "Password recovering"
      flash.now[:error] = "Email is invalid"
      render :forget
    end
  end
  
  def recovery # Here will be token checking
               # If all good, we will see the form. If no, we will see the error message
    @title = "Password recovery"
    @identity = Identity.find(params[:identity])
    if @identity
      if params_checked?
        @title = "Password recovery"
      else
        fail_recovery
      end
    else
      fail_recovery
    end
  end
  
  def password_changed # We send something from def recovery here
    @identity = Identity.find(params[:identity])
    if params_checked?
      @identity.password = params[:password]
      @identity.password_confirmation = params[:password_confirmation]
      if @identity.save
        @identity.update_attribute(:password_digest, BCrypt::Password.create(@identity.password))
        redirect_to root_path, :notice => "Your password was changed"
      else
        render :recovery
      end
    else
      fail_recovery
    end
  end
  
  private
  
  def fail_recovery # if something going wrong
    redirect_to root_path, :notice => "Fail to recovery"
  end
  
  def params_checked? # check params to recovery. If all good, return true. Otherwise, false
    params[:token] == Digest::SHA2.hexdigest(@identity.id.to_s + @identity.password_digest) && params[:identity] != nil
  end
end
