# frozen_string_literal: true

class Api::V1::Statuses::FavouritesController < Api::BaseController
  include Authorization

  before_action -> { doorkeeper_authorize! :write }
  before_action :require_user!

  respond_to :json

  def create
    @status = favourited_status
    render json: @status, serializer: REST::StatusSerializer
    Bonu.create({ user_id: current_user.id, score: 10, level: 1, ontributor: nil })
  end

  def destroy
    @status = requested_status
    @favourites_map = { @status.id => false }

    UnfavouriteWorker.perform_async(current_user.account_id, @status.id)

    render json: @status, serializer: REST::StatusSerializer, relationships: StatusRelationshipsPresenter.new([@status], current_user&.account_id, favourites_map: @favourites_map)
    Bonu.create({ user_id: current_user.id, score: -10, level: 1, ontributor: nil })
  end

  private

  def favourited_status
    service_result.status.reload
  end

  def service_result
    FavouriteService.new.call(current_user.account, requested_status)
  end

  def requested_status
    Status.find(params[:status_id])
  end
end
