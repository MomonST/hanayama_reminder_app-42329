class ApplicationController < ActionController::Base
  before_action :basic_auth, unless: -> { Rails.env.test? }
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  protected
  
  # Deviseのストロングパラメータ設定
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:nickname, :first_name, :last_name, :first_name_kana, :last_name_kana, :birth_date, :region])
    devise_parameter_sanitizer.permit(:account_update, keys: [:nickname, :first_name, :last_name, :first_name_kana, :last_name_kana, :birth_date, :region])
  end

  private

  def basic_auth
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV["BASIC_AUTH_USER"] && password == ENV["BASIC_AUTH_PASSWORD"]  # 環境変数を読み込む記述に変更
    end
  end
end