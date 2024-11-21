# app/channels/game_channel.rb

class GameChannel < ApplicationCable::Channel
  def subscribed
    # Ensure the game_id is correctly received and find the game
    @game = Game.find(params[:game_id])
    stream_for @game  # This creates a unique broadcast stream for each game
  end

  def set_current_user(data)
    @current_user =  data['current_user']
    GameChannel.broadcast_to(@game, sender: @current_user, type: "connection", message: "connected")
  end

  def unsubscribed
    # Any cleanup when channel is unsubscribed
    GameChannel.broadcast_to(@game, sender: @current_user, type: "connection", message: "disconnected")
  end

  def speak(data)
    message = data['message']
    type = data['type']
    sender = data['sender']
    # Send only to the current subscriber
    GameChannel.broadcast_to(@game, sender: sender, type: type, message: message)  # Broadcast only to this game's stream
  end
end
 