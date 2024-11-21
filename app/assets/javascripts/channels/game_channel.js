// app/javascript/channels/game_channel.js

function showResponsePopUp(message){
    const responsePopUp = document.getElementById('responsePopUp');
    const responseText = document.getElementById('responseText');
    responseText.innerText = message;
    responsePopUp.style.display = 'block';

    setTimeout(()=>{
        responsePopUp.style.display = 'none';
    },2000)
}

import { createConsumer } from "@rails/actioncable"

const consumer = createConsumer()
const cardContainer = document?.getElementById('card-container');
const gameContainer = document?.getElementById('game');
const nPlayer = cardContainer?.getAttribute('data-n-player');
const urlPath = window.location.pathname;
const fullURL = window.location.href
const urlSplitted = fullURL?.split("/")
const pathSplitted = urlPath.split('/')
const currentUser = pathSplitted[pathSplitted.length-3]
const gameId = pathSplitted.pop()
const saveDiscardedCharactersButton = document.getElementById('saveDiscardedCharactersButton');

var originalDiscardedCharacters = !cardContainer?.getAttribute('data-discarded-characters') ? [] : cardContainer?.getAttribute('data-discarded-characters').split(",");
const actualDiscardedCharacters = [...originalDiscardedCharacters]
const males = ['aldo',"giacomo", "giovanni", "luca", "mariello", "lucio", "mario", "olmo", "paolo", "pino", "sergio", "simone"];
const females = ['anna', 'aurora', "ilaria", 'elisa', "emma", "federica", "gaia", "giulia", "jessica", "lucia", "margherita", "martina"];
const gameChannel = consumer.subscriptions.create({ channel: "GameChannel", game_id: gameId }, {
    connected() {
        console.log("Connected to the game channel for game ID:", gameId);
        console.log("Connected with user:", currentUser);
        gameChannel.set_current_user(currentUser); // Add message_type as 'chat'
    },

    disconnected() {
        gameChannel.speak(currentUser, 'disconnect'); // Add message_type as 'chat'

        console.log("Disconnected from the game channel for game ID:", gameId);
    },

    received(data) {
        const messages = document.getElementById('messages');
        console.log(data.sender, currentUser, currentUser !== data.sender)
        if(currentUser !== data.sender){
            if(data.type === "question") {
                const questionModal = document.getElementById('questionModal');
                const questionText = document.getElementById('questionText');
                questionText.innerText = data.message;
                questionModal.style.display = 'block';
                
            } 
            else if(data.type === "answer") {
                createQuestionsGame()
            } 
            else if(data.type === "response") {
                showResponsePopUp(data.message)
                // const lastResponse = document.getElementById('last_response');
                // lastResponse.innerText = data.message
                
            } 
            else if(data.type === "end_game") {
                showResponsePopUp(data.message)
                window.location.href = pathSplitted.slice(0,urlSplitted.length-1).join("/")

            } 
            else if (data.type==="connection"){
                if(data.message === "connected") {
                    if(data.message !== currentUser){
                        this.speak(currentUser, "connection", "alreadyConnected")
                        document.getElementById('loader_game').className = document.getElementById('loader_game').className + " hidden";
                        gameContainer.className = gameContainer.className.replaceAll(" hidden", "");
                    }
                }
                else if(data.message === "disconnected") {
                    if(data.message !== currentUser){
                        gameContainer.className = gameContainer.className + " hidden";
                        document.getElementById('loader_game').className = document.getElementById('loader_game').className.replaceAll(" hidden", "");
                    }
                
                }
                else if(data.message === "alreadyConnected") {
                    if(data.message !== currentUser){
                        document.getElementById('loader_game').className = document.getElementById('loader_game').className + " hidden";
                        gameContainer.className = gameContainer.className.replaceAll(" hidden", "");
                    }
                }
            }
            else {
                messages.innerHTML += `<p>${data.message}</p>`;
            }
        }
        else {
            if(data.type === "question") {
                const lastQuestion = document.getElementById('last_question');
                lastQuestion.innerText = data.message
            }
        }
    },

    speak: function(sender, type, message) {
        return this.perform('speak', { sender, type, message });
    },
    set_current_user: function(current_user) {
        return this.perform('set_current_user', { current_user });
    }
});


document.addEventListener('DOMContentLoaded', () => {
  const yesBtn= document.getElementById('yesButton')
  yesBtn && yesBtn.addEventListener('click', function() {
      gameChannel.speak(currentUser, "response", "Yes");
      document.getElementById('questionModal').style.display = 'none';
      createQuestionsGame();
  });

  const noBtn = document.getElementById('noButton')
  noBtn && noBtn.addEventListener('click', function() {
      gameChannel.speak(currentUser, "response", "No");
      document.getElementById('questionModal').style.display = 'none';
      createQuestionsGame();
  });


});

document.addEventListener('DOMContentLoaded', () => {
    const input = document?.getElementById('message_input');
    const sendButton = document.getElementById('send_button');
    console.log(sendButton)
  
    // Send message when "Enter" is pressed
    input && input?.addEventListener('keypress', (event) => {
      if (event.key === 'Enter') {
        sendQuestionEL(event, input)
      }
    });
  
    if (!sendButton) return;
  
    // Send message when the "Send" button is clicked
    sendButton&&sendButton?.addEventListener('click', (event) => {
        sendQuestionEL(event, input)
    });
  });

  document.addEventListener('DOMContentLoaded', () => {
    const selectElement = document.querySelector('#questions_game select');
    const sendAnswerButton = document.getElementById('send_answer_button');

    if (!sendAnswerButton) return;

    // Send selected character when the "Send" button is clicked
    sendAnswerButton.addEventListener('click', () => {
        const selectedCharacter = selectElement.value; // Get the selected value
        sendAnswerEL(selectedCharacter)
    });
});

const createQuestionsGame = () => {
    // Create the main container div
    const questionsGameDiv = document.createElement("div");
    questionsGameDiv.id = "questions_game";
  
    // Create and append the first heading
    const sendQuestionHeading = document.createElement("h3");
    sendQuestionHeading.textContent = "Send question";
    questionsGameDiv.appendChild(sendQuestionHeading);
  
    // Create the first form
    const questionForm = document.createElement("form");
  
    const messageInput = document.createElement("input");
    messageInput.type = "text";
    messageInput.id = "message_input";
    messageInput.placeholder = "Enter your question here...";
    questionForm.appendChild(messageInput);
  
    const sendButton = document.createElement("button");
    sendButton.type = "button";
    sendButton.id = "send_button";
    sendButton.textContent = "Send";
  
    // Add event listener to the first button
    sendButton.addEventListener("click", (event, input) => {
        sendQuestionEL(event, messageInput);
    });
  
    questionForm.appendChild(sendButton);
    questionsGameDiv.appendChild(questionForm);
  
    // Create and append the second heading
    const chooseCharacterHeading = document.createElement("h3");
    chooseCharacterHeading.textContent = "Choose a character";
    questionsGameDiv.appendChild(chooseCharacterHeading);
  
    // Create the second form
    const characterForm = document.createElement("form");
  
    const characterSelect = document.createElement("select");
    characterForm.appendChild(characterSelect);
  
    const sendAnswerButton = document.createElement("button");
    sendAnswerButton.type = "button";
    sendAnswerButton.id = "send_answer_button";
    sendAnswerButton.textContent = "Send";
  
    // Add event listener to the second button
    sendAnswerButton.addEventListener("click", () => {
      const selectedOption = characterSelect.value;
      sendAnswerEL(selectedOption)
    });
  
    characterForm.appendChild(sendAnswerButton);
    questionsGameDiv.appendChild(characterForm);
  
    // Append the div to the body or another container in the DOM
    const gameContainer = document.getElementById("game");
    if (gameContainer) {
      gameContainer.appendChild(questionsGameDiv);
      updateSelectOptions()
    } else {
      console.error("No container with ID 'game' found.");
    }
};
  
function removeQuestionsGame() {
const questionsGameDiv = document.getElementById("questions_game");
    if (questionsGameDiv) {
        questionsGameDiv.remove();
    } else {
        console.warn("No element with ID 'questions_game' found to remove.");
    }
}

const sendQuestionEL = (event, input) =>{
    if(input.value.trim()!==""){
        gameChannel.speak(currentUser, 'question', input.value); // Add message_type as 'chat'
        input.value = '';
        event.preventDefault();
        fetch(`/games/${gameId}/toggle_round`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
            },
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                removeQuestionsGame()
            } else {
                alert("Error toggle turn");
            }
        })
        .catch(error => {
            alert("Error looking for opponent selected characte", error);
    
        });

    }
}
const sendAnswerEL = (selectedCharacter) =>{
    if (selectedCharacter.trim() !== '') {
        fetch(`/games/${gameId}/is_answer_correct`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
            },
            body: JSON.stringify({
                player: nPlayer,
                character: selectedCharacter,
            })
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                if(!!data?.isCorrect){
                    showResponsePopUp("You Won")
                    window.location.href = urlSplitted.slice(0,urlSplitted.length-1).join("/")
                    gameChannel.speak(currentUser, 'end_game', "You Lose"); 

                }
                else{
                    showResponsePopUp("Answer Wrong")
                    fetch(`/games/${gameId}/toggle_round`, {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json',
                            'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
                        },
                    })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            removeQuestionsGame()
                        } else {
                            alert("Error toggle turn");
                        }
                    })
                    .catch(error => {
                        alert("Error looking for opponent selected characte", error);
                
                    });
                
                }

                gameChannel.speak(currentUser, 'answer'); 
                removeQuestionsGame()
            } else {
                alert("Error looking for opponent selected character");
            }
        })
        .catch(error => {
            alert("Error looking for opponent selected characte", error);
    
        });
    }
}
// Function to update the select options with non-discarded characters
const updateSelectOptions = () => {
  // Get the select element
  const selectElement = document.querySelector('#questions_game select');
  if(selectElement){
    // Clear existing options
    selectElement.innerHTML = '';

    // Combine males and females into one array
    const allCharacters = [...males, ...females];

    // Filter out discarded characters
    const nonDiscardedCharacters = allCharacters.filter(name => !actualDiscardedCharacters.includes(name));

    // Add a default option
    const defaultOption = document.createElement('option');
    defaultOption.value = '';
    defaultOption.textContent = 'Choose a character';
    selectElement.appendChild(defaultOption);

    // Add non-discarded characters as options
    nonDiscardedCharacters.forEach(name => {
        const option = document.createElement('option');
        option.value = name;
        option.textContent = name;
        selectElement.appendChild(option);
    });
  }
}

function arraysHaveSameValues(arr1, arr2) {
  // First, check if the arrays have the same length
  if (arr1.length !== arr2.length) {
    return false;
  }

  // Sort both arrays
  const sortedArr1 = arr1.slice().sort();
  const sortedArr2 = arr2.slice().sort();

  // Compare each value
  for (let i = 0; i < sortedArr1.length; i++) {
    if (sortedArr1[i] !== sortedArr2[i]) {
      return false;
    }
  }

  // If all checks passed, the arrays have the same values
  return true;
}





// Function to create a card
function createCard(name, gender) {
    const card = document.createElement('div');
    card.className = 'flip-card-game self-center w-[100px]'
    const cardInner = document.createElement('div');
    cardInner.className = 'flip-card-game-inner cursor-pointer';

    const cardFront = document.createElement('div');
    cardFront.className = 'flip-card-game-front overflow-hidden text-center text-white bg-blue-500 rounded-t-xl border-4 border-black cursor-pointer';

    const cardFrontImage = document.createElement('img');
    cardFrontImage.src=`/images/games/characters/${name}.png`
    cardFrontImage.className="object-fill"

    const cardFrontFooter = document.createElement('div');
    const cardFrontFooterText = document.createElement('div');
    if(gender==="male")
      cardFrontFooter.className = 'absolute bottom-0 border-none bg-blue-500 text-white overflow-y-scroll w-[92px]';
    else 
      cardFrontFooter.className = 'absolute bottom-0 border-none bg-pink-500 text-white overflow-y-scroll w-[92px]';

    cardFrontFooterText.textContent = name;  // Set the name to display on the front

    cardFrontFooter.appendChild(cardFrontImage);
    cardFrontFooter.appendChild(cardFrontFooterText);
    cardFront.appendChild(cardFrontFooter);
    
    const cardBack = document.createElement('div');
    cardBack.className = 'flip-card-game-back p-5 text-center text-white bg-black rounded-b-xl border-4 border-black';


    // Append the front and back to the inner container
    cardInner.appendChild(cardFront);
    cardInner.appendChild(cardBack);

    // Append the inner container to the main card element
    card.appendChild(cardInner);
    if(originalDiscardedCharacters.includes(name)){
      card.classList.toggle('flipped');
    }
    // Add flip functionality
    card.addEventListener('click', function () {
        saveDiscardedCharactersButton.onclick = function () {
            fetch(`/games/${gameId}/save_discarded_characters`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
                },
                body: JSON.stringify({
                    player: nPlayer,
                    discardedCharacters: actualDiscardedCharacters.join(",")
                })
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                  originalDiscardedCharacters = [...actualDiscardedCharacters]
                  saveDiscardedCharactersButton.className = saveDiscardedCharactersButton.className.replaceAll(" hidden", "")
                  saveDiscardedCharactersButton.className = saveDiscardedCharactersButton.className + " hidden"
                } else {
                    alert("Error saving changes");
                }
            })
            .catch(error => {
                alert("Error saving changes", error);
          
            });
          }
        this.classList.toggle('flipped');
        const index = actualDiscardedCharacters.indexOf(name)
        if(index > -1){
          actualDiscardedCharacters.splice(index, 1)
        }
        else {
          actualDiscardedCharacters.push(name)
        }
        if(arraysHaveSameValues(originalDiscardedCharacters, actualDiscardedCharacters)){
          saveDiscardedCharactersButton.className = saveDiscardedCharactersButton.className.replaceAll(" hidden", "")
          saveDiscardedCharactersButton.className = saveDiscardedCharactersButton.className + " hidden"

        }
        else{
          saveDiscardedCharactersButton.className = saveDiscardedCharactersButton.className.replaceAll(" hidden", "")
        }
        updateSelectOptions();
    });

    return card;
}


document.addEventListener('DOMContentLoaded', () => {
    // Create and append cards for each name in the array
    males.forEach(name => {
        cardContainer.appendChild(createCard(name, "male"));
    });
    females.forEach(name => {
        cardContainer.appendChild(createCard(name, "female"));
    });

    updateSelectOptions();
    createSelectedCharacterCard()
})
//selected-character

// Function to create a card
function createSelectedCharacterCard() {
    const container = document?.getElementById('selected-character');
    const name = container?.getAttribute('data-selected-character-name');
    const gender = males.includes(name) ? "male" : "female"
    const card = document.createElement('div');
    card.className = 'self-center w-[100px]'
    const cardInner = document.createElement('div');
    cardInner.className = 'flip-card-game-inner'; //TODO: check

    const cardFront = document.createElement('div');
    cardFront.className = 'flip-card-game-front overflow-hidden text-center text-white bg-blue-500 rounded-t-xl border-4 border-black';// TODO: check

    const cardFrontImage = document.createElement('img');
    cardFrontImage.src=`/images/games/characters/${name}.png`
    cardFrontImage.className="object-fill"

    const cardFrontFooter = document.createElement('div');
    const cardFrontFooterText = document.createElement('div');
    if(gender==="male")
      cardFrontFooter.className = 'absolute bottom-0 border-none bg-blue-500 text-white overflow-y-scroll w-[92px]';
    else 
      cardFrontFooter.className = 'absolute bottom-0 border-none bg-pink-500 text-white overflow-y-scroll w-[92px]';

    cardFrontFooterText.textContent = name;  // Set the name to display on the front

    cardFrontFooter.appendChild(cardFrontImage);
    cardFrontFooter.appendChild(cardFrontFooterText);
    cardFront.appendChild(cardFrontFooter);
    


    // Append the front and back to the inner container
    cardInner.appendChild(cardFront);

    // Append the inner container to the main card element
    card.appendChild(cardInner);
    // Add flip functionality

    container.appendChild(card); ;
}