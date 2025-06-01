class FlowerMailer < ApplicationMailer
  default from: 'notifications@hanayama-reminder.com'
  
  def bloom_reminder(user, flower, mountain)
    @user = user
    @flower = flower
    @mountain = mountain
    @days_left = flower_mountain.days_until_peak
    
    mail(
      to: @user.email,
      subject: "【花山リマインダー】#{@flower.name}の見頃まであと#{@days_left}日です"
    )
  end
end