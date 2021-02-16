class ChangeTeamOwnerMailer < ApplicationMailer
  default from: 'from@example.com'
  layout 'mailer'

  def change_team_owner_mail(user, team)
    @user = user
    @email = @user.email
    @team = team
    mail to: @email, subject: "チームリーダーに任命されました"
  end
end
