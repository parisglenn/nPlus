class RoundUpMatchUsersController < ApplicationController

  def update
    @round_up_match_user = RoundUpMatchUser.find(params[:id])
    respond_to do |format|
      if @round_up_match_user.update_attributes(params[:round_up_match_user])
        @round_up_match = RoundUpMatch.find(@round_up_match_user.round_up_match.id)
        # @user1, @user2 = @round_up_match.get_users
        # @comments = @round_up_match.comment_threads.order('created_at desc')
        # @new_comment = Comment.build_from(@round_up_match, current_user.id, "")
        format.html { redirect_to edit_round_up_match_path(@round_up_match.id)
        # format.html { render partial: 'round_up_matches/display_round_up_match'
        #  redirect_to root_url, notice: 'Rsvp was successfully updated.' 
        }
        
        format.json { head :no_content }
      else
        format.html { render root_url }
        format.json { render json: @round_up_match.errors, status: :unprocessable_entity }
      end
    end
  end

  def rsvp
    record = RoundUpRsvpCode.where(code: params[:code]).first
    if record
      match_user = RoundUpMatchUser.where(user_id: record.user_id, round_up_match_id: record.round_up_match_id).first
      if match_user.round_up_match.expires_at < Time.now
        records = RoundUpRsvpCode.where(user_id: record.user_id, round_up_match_id: record.round_up_match_id)
        match_user.rsvp = record.action
        match_user.save
      else
        @message = "Your Round Up match has expired."
      end
    else
      @message = "Round Up appointment could not be found or you have already RSVP'd to this Round Up match"
    end
  end
  /round_up_match_user/rsvp/code 
end