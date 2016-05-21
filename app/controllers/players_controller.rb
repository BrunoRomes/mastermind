class PlayersController < ApplicationController

  def create
    @game = game_interactor.get(params[:game_id])
    @player = interactor.create(@game, params[:player])
    respond_to do |format|
      format.json { render "games/show_with_player", status: :created, location: game_url(@game.game_key)}
    end
  end

  private

    def game_interactor
      GameInteractor.instance
    end

    def interactor
      PlayerInteractor.instance
    end

end