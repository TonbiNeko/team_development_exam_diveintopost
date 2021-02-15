class TeamsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_team, only: %i[show edit update destroy change_owner]

  def index
    @teams = Team.all
  end

  def show
    @working_team = @team
    change_keep_team(current_user, @team)
  end

  def new
    @team = Team.new
  end

  def edit
    unless current_user.id == @team.owner_id
      flash.now[:error] = I18n.t('views.messages.failed_to_save_team')
      render :show
    end
  end

  def create
    @team = Team.new(team_params)
    @team.owner = current_user
    if @team.save
      @team.invite_member(@team.owner)
      redirect_to @team, notice: I18n.t('views.messages.create_team')
    else
      flash.now[:error] = I18n.t('views.messages.failed_to_save_team')
      render :new
    end
  end

  def update
    if current_user.id == @team.owner_id
      if @team.update(team_params)
        redirect_to @team, notice: I18n.t('views.messages.update_team')
      else
        flash.now[:error] = I18n.t('views.messages.failed_to_save_team')
        render :edit
      end
    else
      flash.now[:error] = I18n.t('views.messages.failed_to_save_team')
      render :show
    end
  end

  def destroy
    @team.destroy
    redirect_to teams_url, notice: I18n.t('views.messages.delete_team')
  end

  def dashboard
    @team = current_user.keep_team_id ? Team.find(current_user.keep_team_id) : current_user.teams.first
  end

  def change_owner
    if current_user.id == @team.owner_id
      @team.update(owner_id: params[:user_id])
      @new_owner = User.find_by(id: @team.owner_id)
      ChangeTeamOwnerMailer.change_team_owner_mail(@new_owner, @team).deliver
      redirect_to @team, notice: "チームリーダーを変更しました"
    else
      render :show, notice: "リーダーだけが権限を移動できます"
    end
  end

  private

  def set_team
    @team = Team.friendly.find(params[:id])
  end

  def team_params
    params.fetch(:team, {}).permit %i[name icon icon_cache owner_id keep_team_id]
  end
end
