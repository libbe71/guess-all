class GamesController < ApplicationController
  before_action :authorize_user!, except: [:new, :check_game, :set_winner]
  before_action :set_game, only: [:show, :select_character, :save_selected_character, :save_discarded_characters, :is_answer_correct, :set_winner, :toggle_round, :make_move, :history, :opponent_cards_left, :check_game]
  before_action :ensure_character_selected, only: [:show]
  before_action :ensure_character_not_selected, only: [:select_character]
  before_action :authorize_moderator!, only: [:check_game, :set_winner]

  

  def index
    @games = Game.where(status: "started")
                 .where("player1_id = :user OR player2_id = :user", user: @current_user.id)
                 .order(created_at: :desc)
    @ended_games = Game.where(status: "finished")
                .where("player1_id = :user OR player2_id = :user", user: @current_user.id)
                .order(created_at: :desc)
  end


  def check_game
    @current_user = User.find(params[:id])
    @moves = @game.moves
  end

  # Show a specific game (gameplay view)
  def show
    # Game will be rendered in a WebSocket room (handled below)
  end
  def history
    @moves = @game.moves
  end
 
  # Show a specific game (gameplay view)
  def select_character
  end

  def set_winner
    playerId=params[:playerId]

    # Ensure only authorized users can set the winner
    # Update game status and winner
    if @game.update(status: 'finished', winner_id: playerId)
      render json: { success: true }, status: :ok
    else
      render json: { success: false, error: 'Failed to update game', details: @game.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def toggle_round
    if @game.round_id === @game.player1.id
      @game.update(round_id: @game.player2.id)
    elsif
      @game.update(round_id: @game.player1.id)
    end

    if @game.save
      render json: { success: true }
    else
      render json: { success: false, errors: @game.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  
  def is_answer_correct
    if params[:player] == "1"
      if @game.player2_choosen_character == params[:character]
        if @game.update(status: 'finished', winner_id: @current_user.id)
          render json: { success: true, isCorrect: true }, status: :ok
        else
          render json: { success: false, error: 'Failed to update game status and winner', details: @game.errors.full_messages }, status: :unprocessable_entity
        end
      else
        render json: { success: true, isCorrect: false }, status: :ok
      end
    elsif params[:player] == "2"
      if @game.player1_choosen_character == params[:character]
        if @game.update(status: 'finished', winner_id: @current_user.id)
          render json: { success: true, isCorrect: true }, status: :ok
        else
          render json: { success: false, error: 'Failed to update game status and winner', details: @game.errors.full_messages }, status: :unprocessable_entity
        end
      else
        render json: { success: true, isCorrect: false }, status: :ok
      end
    else
      render json: { success: false, errors: @game.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def save_discarded_characters
    if params[:player] == "1"
      @game.update(player1_characters_discarded: params[:discardedCharacters])
    elsif params[:player] == "2"
      @game.update(player2_characters_discarded: params[:discardedCharacters])
    end

    if @game.save
      render json: { success: true }
    else
      render json: { success: false, errors: @game.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def save_selected_character
    if params[:player] == "1"
      @game.update(player1_choosen_character: params[:character])
    elsif params[:player] == "2"
      @game.update(player2_choosen_character: params[:character])
    end

    if @game.save
      render json: { success: true }
    else
      render json: { success: false, errors: @game.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def opponent_cards_left       
    opponent_discarded_cards = if params[:player] == "1"
                       @game.player2_characters_discarded
                     elsif params[:player] == "2"
                       @game.player1_characters_discarded
                     end
    number_opponent_discarded_cards = opponent_discarded_cards.split(",").length                
    opponent_cards_left = 24-number_opponent_discarded_cards
    if opponent_cards_left
      render json: { success: true, opponent_cards_left: opponent_cards_left  }
    else
      render json: { success: false, errors: @game.errors.full_messages }, status: :unprocessable_entity
    end
  end
  

  def after_character_selected
  end
  # Create a new game session between two users
  def new
    if !params[:game] && !params[:game][:player2_id]
      flash[:alert] = "You are not authorized to access this page."
      redirect_to root_path
    end
    @game = Game.new(player1: @current_user, player2_id: params[:game][:player2_id], status: "started", player1_characters_discarded: "", player2_characters_discarded: "", round_id: @current_user.id)

    if @game.save
      render json: { success: true, game_id: @game.id }
    else
      render json: { success: false, errors: @game.errors.full_messages }, status: :unprocessable_entity
    end

  end

  # Create a new game session between two users
  def Create
  end
  
  def make_move
    question = params[:question]
    answer = params[:answer]
    position = @game.moves.count + 1

    # Create the move with the current user
    @game.moves.create!(
      question: question,
      answer: answer,
      position: position,
      user: @current_user
    )

    render json: { success: true }
  end

  private
  
  def ensure_character_selected
    game = Game.find(params[:gameId])

    if game.player1.id == @current_user.id
      redirect_to "/#{@current_locale}/user/#{@current_user["id"]}/games/#{game.id}/select_character/1" unless game.player1_choosen_character.present?
    elsif game.player2.id == @current_user.id
      redirect_to "/#{@current_locale}/user/#{@current_user["id"]}/games/#{game.id}/select_character/2" unless game.player2_choosen_character.present?
    end
  end

  def ensure_character_not_selected
    game = Game.find(params[:gameId])

    
    if (game.player1.id == @current_user.id && game.player1_choosen_character) || (game.player2.id == @current_user.id && game.player2_choosen_character)
      redirect_to "/#{@current_locale}/user/#{@current_user["id"]}/games/#{game.id}"
    end
  end

  def set_game
    @game = Game.find(params[:gameId])
  end

  def game_params
    params.require(:game).permit(:player2_id)
  end

end

