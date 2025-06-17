class SeedsController < ApplicationController
  # 注意！一時的にだけ公開して、すぐに削除or制限しよう
  def run
    if ENV['ALLOW_SEED'] == 'true'
      load(Rails.root.join('db/seeds.rb'))
      render plain: "Seed executed!"
    else
      head :forbidden
    end
  end
end
