module SessionsHelper
  def current_user
    User.find_by_session_token(session[:session_token])
  end

  def log_in(user)
    @current_user = user
    session[:session_token] = user.session_token
  end

  def logout_current_user!
    current_user.reset_session_token!
    session[:session_token] = nil
  end

  def require_current_user!
    redirect_to new_session_url if current_user.nil?
  end

  def require_no_current_user!
    redirect_to user_url(current_user) unless current_user.nil?
  end

  # either site administrator or librarian
  def is_admin?(user)
    user.admin > 0
  end

  # only one site administrator
  def is_administrator?(user)
    user.admin == 2
  end

  def require_admin_status!
    unless is_admin?(current_user)
      flash.now[:errors] = ["Must be librarian"]
      redirect_to user_url(current_user)
    end
  end

  def require_administrator!
    unless is_administrator?(current_user)
      flash[:errors] = ["Must be site administrator"]
      redirect_to root_url
    end
  end

end