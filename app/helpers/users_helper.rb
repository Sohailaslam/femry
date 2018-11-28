module UsersHelper
	def show_avatar(user)
    if user.avatar.attached?
      image_tag(avatar_url(user), class: 'avatar-circle')
    else
      render partial: 'shared/avatar', locals: {user: user}
    end
  end
end
