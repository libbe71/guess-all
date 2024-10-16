// app/javascript/packs/game_channel.js
import consumer from "./consumer"

document.addEventListener('DOMContentLoaded', () => {
  const gamePlayArea = document.getElementById('game-play-area');
  const gameId = gamePlayArea ? gamePlayArea.dataset.gameId : null;
  if (!gameId) return;

  const moveInput = document.getElementById('move-input');
  const moveButton = document.getElementById('make-move-button');

  const gameChannel = consumer.subscriptions.create({ channel: "GameChannel", game_id: gameId }, {
    received(data) {
      console.log("Received data:", data);
      // Update the game play area with new move results
      // gamePlayArea.textContent = `Latest move: ${data.move}`;
    },

    connected() {
      console.log("Connected to GameChannel");
    },

    disconnected() {
      console.log("Disconnected from GameChannel");
    },

    rejected() {
      console.log("Subscription rejected. Check if the game ID is correct and the user is authorized to subscribe.");
    },

    make_move: function(move) {
      this.perform('make_move', { move: move, game_id: gameId });
    }
  });

  moveButton.addEventListener('click', () => {
    const move = moveInput.value;
    gameChannel.make_move(move);
    moveInput.value = ''; // Clear the input after sending the move
  });
});
