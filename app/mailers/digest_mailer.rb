class DigestMailer < ApplicationMailer
  add_template_helper(UsersHelper)
  add_template_helper(PostsHelper)

  # TODO: change mail to: @user.email when it's production ready
  def daily_email(user)
    @user = user
    @recommended = Post.latest(4).published
    mail to: 'duleep.daniel@gmail.com', subject: 'Daily Digest'
  end
end
