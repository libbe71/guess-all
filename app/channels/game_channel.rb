class GameChannel < ApplicationCable::Channel
  def subscribed
    # Find the game by ID sent from the client and stream for that game
    @game = Game.find_by(id: params[:game_id])
    stream_for @game
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def make_move(data)
    @game = Game.find_by(id: data["game_id"])
    
    if @game
      # Assuming `move` is a method to handle game logic and save the state
      move_result = @game.move(data["move"], current_user)
      GameChannel.broadcast_to(@game, move_result)
    else
      # Handle the case where the game isn't found
      transmit { error: "Game not found" }, status: :not_found
    end
  end
end
