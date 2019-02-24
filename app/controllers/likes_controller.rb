class LikesController < ApplicationController
  include LikeHelper

  load_and_authorize_resource

  def create
    @likable = @like.likable
    if user_signed_in?
      @like.user = current_user
      errors_to_flash(@like) unless @like.save
    else
      ActiveRecord::Base.transaction do
        if !anonymous_liked?(@like.likable)
          if @likable.increment!(:anonymous_likes_count)
            mark_anonymous_liked @likable
          else
            errors_to_flash(@like)
          end
        end
      end
      @likable.reload
    end

    merge_likes_counts
  end

  def cancel
    if !user_signed_in?
      flash[:notice] = '로그인해서 공감한 경우만 취소됩니다.'
      return
    end

    @like = Like.find_by!(likable: Like.new(like_params).likable, user: current_user)
    @likable = @like.likable
    @like.try(:destroy)

    merge_likes_counts
  end

  private

  def like_params
    params.require(:like).permit(:likable_id, :likable_type)
  end

  def merge_likes_counts
    if @likable.has_attribute?(:merged_likes_count)
      @likable.update_attributes!(merged_likes_count: @likable.anonymous_likes_count + @likable.likes_count)
    end
  end
end
