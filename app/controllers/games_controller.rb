class GamesController < ApplicationController

  def index
    @games = interactor.all_available()
  end

  def create
    @game = interactor.create(game_params)
    @player = @game.players.first
    respond_to do |format|
      format.json { render :show, status: :created}
    end
  end

  private

    def interactor
      GameInteractor.instance
    end

    def game_params
      params.permit(:player, :number_of_players, :allow_repetition, :max_turns)
    end

end