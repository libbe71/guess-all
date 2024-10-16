class GamesController < ApplicationController
  before_action :set_game, only: [:show]

  # List all games (e.g. all started or finished games)
  def index
    @games = Game.where(status: ["started", "finished"]).order(created_at: :desc)
  end

  # Show a specific game (gameplay view)
  def show
    # Game will be rendered in a WebSocket room (handled below)
  end

  # Create a new game session between two users
  def new
    if !params[:game] && !params[:game][:player2_id]
      flash[:alert] = "You are not authorized to access this page."
      redirect_to root_path
    end
    @game = Game.new(player1: @current_user, player2_id: params[:game][:player2_id], status: "started")

    if @game.save
      render json: { success: true, game_id: @game.id }
    else
      render json: { success: false, errors: @game.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # Create a new game session between two users
  def Create
  end

  private

  def set_game
    @game = Game.find(params[:id])
  end

  def game_params
    params.require(:game).permit(:player2_id)
  end
end
