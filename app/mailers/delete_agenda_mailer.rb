class DeleteAgendaMailer < ApplicationMailer
  default from: 'from@example.com'
  layout 'mailer'

  # def delete_agenda_mail(agenda)
  #   @agenda = agenda
  #   # @members = @agenda.team.assigns
  #   # @agenda.team.assigns.last.user_id 
  #   # ids = @members.map(&:user_id) チームメンバーのidを配列にした
  #   # u = User.where(id: ids) ユーザー情報ゲット
  #   # u.map(&:email)
  #   user_ids = @agenda.team.assigns.pluck(:user_id)
  #   emails = User.where(id: user_ids).pluck(:email)

  def delete_agenda_mail(agenda)
    @agenda = agenda
    @user_ids = @agenda.team.assigns.pluck(:user_id)
    @emails = User.where(id: @user_ids).pluck(:email)
    mail to: @emails, subject: "チームリーダーに任命されました"
  end
end
