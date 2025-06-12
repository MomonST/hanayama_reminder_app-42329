class ApiController < ActionController::API
  include ActionController::Helpers
  include Devise::Controllers::Helpers

  before_action :authenticate_user!
end