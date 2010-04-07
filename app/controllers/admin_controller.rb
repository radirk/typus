class AdminController < ActionController::Base

  unloadable
  filter_parameter_logging :password

  include Typus::Authentication
  include Typus::Preferences
  include Typus::Reloader

  unless ActionController::Base.consider_all_requests_local
    rescue_from Exception, :with => :render_error
  end

  if Typus::Configuration.options[:ssl]
    include SslRequirement
    ssl_required :all
  end

  before_filter :reload_config_and_roles
  before_filter :authenticate
  before_filter :set_preferences

  def index
    redirect_to admin_dashboard_path
  end

  protected

  def render_error(exception)
    log_error(exception)
    flash[:error] = exception.message
    redirect_to admin_path
  end

end