module UsersHelper
	def show_avatar(user)
    if user.avatar.present?
      image_tag(user.avatar.url(:thumb).to_s, class: 'avatar-circle')
    else
      render partial: 'shared/avatar', locals: {user: user}
    end
  end
end
