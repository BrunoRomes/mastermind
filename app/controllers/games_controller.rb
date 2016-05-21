class GamesController < ApplicationController

  def availables
    @games = interactor.all_available
    respond_to do |format|
      format.json { render :index }
    end
  end

  def show
    @game = interactor.get params[:id]
  end

  def create
    @game = interactor.create(game_params)
    @player = @game.players.first
    respond_to do |format|
      format.json { render :show_with_player, status: :created, location: game_url(@game.game_key)}
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