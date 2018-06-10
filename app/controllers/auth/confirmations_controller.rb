# frozen_string_literal: true

class Auth::ConfirmationsController < Devise::ConfirmationsController
  layout 'auth'

  before_action :set_user, only: [:finish_signup]
  after_action :sent_bonus_to_ancestry, only: [:show]

  # GET/PATCH /users/:id/finish_signup
  def finish_signup
    return unless request.patch? && params[:user]
    if @user.update(user_params)
      @user.skip_reconfirmation!
      sign_in(@user, bypass: true)

      redirect_to root_path, notice: I18n.t('devise.confirmations.send_instructions')
    else
      @show_errors = true
    end
  end

  private

  def sent_bonus_to_ancestry
    if Bonu.find_by(:user_id => resource.id, :ontributor => nil).nil?
      if resource.nil? or resource.errors.present? or resource.invite_id.blank?
        Bonu.create({ user_id: resource.id, score: 100, level: 1, ontributor: nil })
      else
        invite = Invite.find(resource.invite_id)
        resource.parent = invite.user
        resource.save
        ancestry_ids = resource.ancestry.split("/").reverse
        hash = {1=> 200, 2 => 100, 3 => 50, 4 => 30,5 => 20, 6 => 10}
        ancestry_ids[0..5].each_with_index do |ancestry_id, index|
          Bonu.create({ user_id: ancestry_id, score: hash[index + 1], level: index + 1, ontributor: resource.id })
        end
        Bonu.create({ user_id: resource.id, score: 200, level: 1, ontributor: nil })
      end
    end
  end

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:email)
  end
end
