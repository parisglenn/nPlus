module CommentsHelper
	def get_user(user_id)
		@user = User.find(user_id)
		return @user.first_name + " " + @user.last_name
	end
end