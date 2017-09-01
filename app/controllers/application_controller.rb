class ApplicationController < ActionController::API
  include ExceptionHandler
  before_action :set_locale

  def set_locale
    I18n.locale = params[:lang] || I18n.default_locale
  end

  def t(message_id)
    I18n.t message_id
  end
end
