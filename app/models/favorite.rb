class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :flower_mountain
end
