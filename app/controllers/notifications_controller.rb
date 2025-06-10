class NotificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_notification, only: [:edit, :update, :destroy]
  
  def index
    @notifications = current_user.notifications
                                .includes(flower_mountain: [:flower, :mountain])
                                .order(:notification_date)
                                .page(params[:page]).per(10)
  end
  
  def new
    @notification = Notification.new
    @flower_mountain_id = params[:flower_mountain_id]
    @flower_mountain = FlowerMountain.find_by(id: @flower_mountain_id)
  end
  
  def create
    @notification = current_user.notifications.build(notification_params)
    @notification.notification_type = 'reminder' 
    @notification.sent = false # 明示的に未送信として設定
    @notification.url = flower_mountain_path(@notification.flower_mountain) if @notification.flower_mountain.present?

    if @notification.save
      redirect_to notifications_path, notice: "通知が正常に設定されました"
    else
      @flower_mountain_id = @notification.flower_mountain_id
      @flower_mountain = FlowerMountain.find_by(id: @flower_mountain_id)
      render :new, status: :unprocessable_entity
    end
  end
  
  def edit
  end
  
  def update
    if @notification.update(notification_params)
      redirect_to notifications_path, notice: "通知設定が更新されました"
    else
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
    params.require(:notification).permit(:flower_mountain_id, :days_before, :notification_type, :url)
  end
end