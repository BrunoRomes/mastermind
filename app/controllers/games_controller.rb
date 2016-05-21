class GamesController < ApplicationController

  def create
    @game = interactor.create(game_params)
    respond_to do |format|
      format.json { render :show, status: :created}
    end
  end

  private

    def interactor
      GameInteractor.instance
    end

    def game_params
      params.permit(:number_of_players, :allow_repetition, :max_turns)
    end

end