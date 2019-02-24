module Likable
  extend ActiveSupport::Concern

  included do
    has_many :likes, as: :likable, dependent: :destroy
  end

  def merged_likes_count
    if has_attribute?(:merged_likes_count)
      return read_attribute(:merged_likes_count)
    end
    anonymous_likes_count + likes_count
  end
end
