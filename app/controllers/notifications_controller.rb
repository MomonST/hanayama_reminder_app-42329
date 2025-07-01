class NotificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_notification, only: [:edit, :update, :destroy]
  
  def index
    @notifications = current_user.notifications
                                .includes(:flower, :mountain)
                                .order(:notification_date)
                                .page(params[:page]).per(10)
  end
  
  def new
    @notification = Notification.new
    @flowers = Flower.all
    @mountains = Mountain.all
  end
  
  def create
    @notification = current_user.notifications.build(notification_params)
    @notification.notification_type = 'reminder' 
    @notification.sent = false # 明示的に未送信として設定

    if @notification.save
      redirect_to notifications_path, notice: "通知が正常に設定されました"
    else
      @flowers = Flower.all
      @mountains = Mountain.all
      render :new, status: :unprocessable_entity
    end
  end
  
  def edit
    @flowers = Flower.all
    @mountains = Mountain.all
  end
  
  def update
    if @notification.update(notification_params)
      redirect_to notifications_path, notice: "通知設定が更新されました"
    else
      @flowers = Flower.all
      @mountains = Mountain.all
      render :edit
    end
  end
  
  def destroy
    @notification.destroy
    redirect_to notifications_path, notice: "通知設定が削除されました"
  end
  
  private
  
  def set_notification
    @notification = current_user.notifications.find(params[:id])
  end
  
  def notification_params
    params.require(:notification).permit(:flower_id, :mountain_id, :days_before, :notification_type)
  end
end