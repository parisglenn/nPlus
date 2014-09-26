class RoundUpMatchesController < ApplicationController

  def edit
    @round_up_match = RoundUpMatch.find(params[:id])
    @user1, @user2 = @round_up_match.get_users
    @comments = @round_up_match.comment_threads.order('created_at desc')
    @new_comment = Comment.build_from(@round_up_match, current_user.id, "")
    @match_user = RoundUpMatchUser.where(user_id: current_user.id, round_up_match_id: @round_up_match.id).first
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @round_up_match }
    end
  end

  def update
    @round_up_match = RoundUpMatch.find(params[:id])
    respond_to do |format|
      if @round_up_match.update_attributes(params[:round_up_match])
        format.html { redirect_to root_url, notice: 'Round up match was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @round_up_match.errors, status: :unprocessable_entity }
      end
    end
  end
end