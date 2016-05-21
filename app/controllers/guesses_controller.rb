class GuessesController < ApplicationController

  def create
    @player = player_interactor.get(params[:player_id])
    @game = @player.game
    interactor.create(@player, @game, guess_params)
    respond_to do |format|
      format.json { render "games/show_with_player", status: :created, location: game_url(@game.game_key)}
    end
  end

  private
    def interactor
      GuessInteractor.instance
    end

    def player_interactor
      PlayerInteractor.instance
    end

    def guess_params
      params.permit(:code)
    end

end