

const gameContainer = document?.getElementById('game');
import { createConsumer } from "@rails/actioncable"
if(gameContainer){
    const consumer = createConsumer()
    const cardContainer = document?.getElementById('card-container');
    const nPlayer = cardContainer?.getAttribute('data-n-player');
    const currentLocale = document
        .querySelector('meta[name="locale"]')
        .getAttribute("content");
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
            if(currentUser !== data.sender){
                if(data.type === "question") {
                    createQuestionModal(data.message, ()=>gameChannel.speak(currentUser, "response", {question: data.message, answer: "Yes"}), ()=>gameChannel.speak(currentUser, "response", {question: data.message, answer:"No"}))
                } 
                else if(data.type === "response") {
                    if(data.message){
                        showResponsePopUp(data.message.answer)
                        makeMove(data.message.question, data.message.answer)

                    }
                    else
                        createQuestionsGame()
                } 
                else if(data.type === "end_game") {
                    showResponsePopUp(data.message)
                    setTimeout(function() {
                        window.location.href = pathSplitted.slice(0,urlSplitted.length-1).join("/")
                    }, 3000);

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
                else if (data.type==="update_cards_left"){
                    updateCardsLeft();
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

        updateCardsLeft()
        const input = document?.getElementById('message_input');
        const sendButton = document.getElementById('send_button');
        const selectElement = document.querySelector('#questions_game select');
        const sendAnswerButton = document.getElementById('send_answer_button');
        // Create and append cards for each name in the array
        males.forEach(name => {
            cardContainer.appendChild(createCard(name, "male"));
        });
        females.forEach(name => {
            cardContainer.appendChild(createCard(name, "female"));
        });

        updateSelectOptions();
        createSelectedCharacterCard()

        if (sendAnswerButton)
            // Send selected character when the "Send" button is clicked
            sendAnswerButton.addEventListener('click', () => {
                const selectedCharacter = selectElement.value; // Get the selected value
                sendAnswerEL(selectedCharacter)
            });
    
        // Send message when "Enter" is pressed
        input && input?.addEventListener('keypress', (event) => {
            if (event.key === 'Enter') {
                event.preventDefault()
                event.stopImmediatePropagation()
                event.stopPropagation()
                sendQuestionEL(event, input)
            }
        });
    
        if (sendButton)
            sendButton?.addEventListener('click', (event) => {
                sendQuestionEL(event, input)
            });
    });


    const createQuestionsGame = () => {
        const game_footer = document.getElementById("game_footer")
        // Create the main container div
        const questionsGameDiv = document.createElement("div");
        questionsGameDiv.id = "questions_game";
        questionsGameDiv.className="p-2 my-4 max-w-sm rounded-md shadow-xl mx-auto text-center dark:border-2 dark:border-tertiary-default"


        const questionsGameH3 = document.createElement("h3");

        if(currentLocale==="it")
            questionsGameH3.textContent = "Fai la tua mossa"
        else if(currentLocale==="en")
            questionsGameH3.textContent = "Make your move"
        questionsGameH3.className = "text-md font-medium text-secondary-default dark:text-tertiary-default mb-5 items-center mx-auto  text-center"
    
    
        const questionFormContainer = document.createElement("div");
        questionFormContainer.className = "flex items-center mx-auto"


        const questionForm = document.createElement("form");
        questionForm.className = "flex items-center mb-4 mx-auto";
    
        const messageInput = document.createElement("input");
        messageInput.className = "flex-grow p-1.5 border-y-2 border-l-2 border-r-none text-sm w-[165px] text-white placeholder-white bg-secondary-default border-secondary-default dark:text-tertiary-default dark:border-tertiary-default dark:bg-transparent dark:placeholder-tertiary-default rounded-l-md focus-visible:ring-transparent focus-visible:border-secondary-default"
        messageInput.type = "text";
        messageInput.id = "message_input";
        if(currentLocale==="it")
            messageInput.placeholder = "Fai una domanda";
        else if(currentLocale==="en")
            messageInput.placeholder = "Enter a question here";
    
        const sendButton = document.createElement("button");
        sendButton.className = "bg-primary-default dark:bg-tertiary-default dark:border-tertiary-default text-white text-sm py-1.5 px-3 rounded-r-md border-y-2 border-primary-default transform hover:scale-x-110 transition duration-300 ease-out"
        sendButton.type = "button";
        sendButton.id = "send_button";
        sendButton.textContent = "->";
          // Send message when "Enter" is pressed
        messageInput && messageInput?.addEventListener('keypress', (event) => {
        if (event.key === 'Enter') {
            event.preventDefault()
            event.stopImmediatePropagation()
            event.stopPropagation()
            sendQuestionEL(event, messageInput)
        }
    });
        // Add event listener to the first button
        sendButton.addEventListener("click", (event, input) => {
            sendQuestionEL(event, messageInput);
        });
        questionsGameDiv.appendChild(questionsGameH3);

        questionForm.appendChild(messageInput);
        questionForm.appendChild(sendButton);
        questionFormContainer.appendChild(questionForm);
        questionsGameDiv.appendChild(questionFormContainer);
        // Create the second form
        const answerForm = document.createElement("form");  

        const answerFormContainer = document.createElement("div");
        answerFormContainer.className = "flex items-center mx-auto"
    
        const characterSelect = document.createElement("select");
        characterSelect.className = "flex-grow cursor-pointer p-1.5 w-[165px] text-sm border-y-2 border-l-2 border-r-none rounded-l-md focus:outline-none  text-white placeholder-white bg-secondary-default border-secondary-default dark:text-tertiary-default dark:border-tertiary-default dark:bg-transparent dark:placeholder-tertiary-default focus-visible:ring-transparent focus-visible:border-secondary-default"
        answerForm.appendChild(characterSelect);
    
        const sendAnswerButton = document.createElement("button");
        sendAnswerButton.type = "button";
        sendAnswerButton.id = "send_answer_button";
        sendAnswerButton.textContent = "->";
        sendAnswerButton.className = "bg-primary-default border-primary-default border-y-2 dark:bg-tertiary-default dark:border-tertiary-default text-white text-sm py-1.5 px-3 rounded-r-md  transform hover:scale-x-110 transition duration-300 ease-out"

    
        // Add event listener to the second button
        sendAnswerButton.addEventListener("click", () => {
        const selectedOption = characterSelect.value;
        sendAnswerEL(selectedOption)
        });
    
        answerForm.appendChild(sendAnswerButton);
        answerFormContainer.appendChild(answerForm);
        questionsGameDiv.appendChild(answerFormContainer)
    
        // Append the div to the body or another container in the DOM
        if (game_footer) {
            game_footer.appendChild(questionsGameDiv);
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
            fetch(`/user/${currentUser}/games/${gameId}/toggle_round`, {
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
            fetch(`/user/${currentUser}/games/${gameId}/is_answer_correct`, {
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
                        let response = "Hai vinto"
                         if(currentLocale==="en")
                            response = "You Won"
                        //here
                        makeMove(selectedCharacter+"?", response)
                        showResponsePopUp(response)
                        setTimeout(function() {
                            window.location.href = urlSplitted.slice(0,urlSplitted.length-1).join("/")
                        }, 3000);
                        gameChannel.speak(currentUser, 'end_game', "You Lose"); 

                    }
                    else{
                        let response = "Risposta sbagliata"
                        if(currentLocale==="en")
                            response = "Answer Wrong"
                        makeMove(selectedCharacter+"?", response)
                        showResponsePopUp(response)
                        fetch(`/user/${currentUser}/games/${gameId}/toggle_round`, {
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

                    gameChannel.speak(currentUser, 'response'); 
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
            

            if(currentLocale==="it")
                defaultOption.textContent = 'Scegli una risposta';
            else if(currentLocale==="en")
                defaultOption.textContent = 'Select an answer';
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
    // Create the modal dynamically using JavaScript
    function createQuestionModal(text = 'Are you sure?', onYes = () => {}, onNo = () => {}) {
        // Create the overlay
        const modalOverlay = document.createElement('div');
        modalOverlay.id = 'questionModal';
        modalOverlay.className = 'fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full';

        // Create the modal content container
        const modalContent = document.createElement('div');
        modalContent.className = 'question-modal-popup';


        // Create the question header
        const questionHeader = document.createElement('H3');
        questionHeader.id = 'questionHeader';
        if(currentLocale==="it"){
            questionHeader.textContent = "Domanda dell'avversario:";
        }
        else{
            questionHeader.textContent = "Opponent question:";
        }
        questionHeader.className = 'mb-2 font-bold text-lg text-secondary-default dark-tertiary';
        
        // Create the question text
        const questionText = document.createElement('p');
        questionText.id = 'questionText';
        questionText.className = 'mb-4 ml-2';
        questionText.textContent = text;

        // Create the Yes button
        const yesButton = document.createElement('button');
        yesButton.id = 'yesButton';
        yesButton.className = 'yes-btn question-modal-btn font-bold py-2 px-4 rounded mr-2 transform hover:scale-x-110 hover:scale-y-105 transition duration-300 ease-out';
        yesButton.textContent = 'Yes';

        // Create the No button
        const noButton = document.createElement('button');
        noButton.id = 'noButton';
        noButton.className = 'no-btn question-modal-btn font-bold py-2 px-4 rounded mr-2 transform hover:scale-x-110 hover:scale-y-105 transition duration-300 ease-out';
        noButton.textContent = 'No';

        // Append buttons and question text to the modal content
        modalContent.appendChild(questionHeader);
        modalContent.appendChild(questionText);
        modalContent.appendChild(yesButton);
        modalContent.appendChild(noButton);

        // Append the modal content to the overlay
        modalOverlay.appendChild(modalContent);

        // Append the modal to the body
        document.body.appendChild(modalOverlay);

        // Function to remove the modal
        function removeModal() {
            if (modalOverlay.parentNode) {
                modalOverlay.parentNode.removeChild(modalOverlay);
            }
        }

        // Attach event listeners to buttons
        yesButton.addEventListener('click', () => {
            onYes(); // Call the Yes callback
            createQuestionsGame()
            removeModal(); // Destroy the modal
            
        });

        noButton.addEventListener('click', () => {
            onNo(); // Call the No callback
            createQuestionsGame()
            removeModal(); // Destroy the modal
        });
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
                fetch(`/user/${currentUser}/games/${gameId}/save_discarded_characters`, {
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
                    gameChannel.speak(currentUser, "update_cards_left")
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

    // Function to create a card
    function createSelectedCharacterCard() {
        const container = document?.getElementById('selected-character');
        const name = container?.getAttribute('data-selected-character-name');
        const gender = males.includes(name) ? "male" : "female"
        const card = document.createElement('div');
        card.className = 'self-center w-[100px] m-auto'
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

    // app/javascript/channels/game_channel.js
    function showResponsePopUp(message) {
        const responsePopUp = document.getElementById('responsePopUp');
        const responseText = document.getElementById('responseText');
        const closePopUpButton = document.getElementById('closePopUp');
    
        responseText.innerText = message;
        responsePopUp.classList.remove('hidden'); // Show the pop-up
    
        // Add click event for the close button
        closePopUpButton.addEventListener('click', () => {
            responsePopUp.classList.add('hidden'); // Hide the pop-up
        });
    }
    
    function makeMove(question, answer){
        fetch(`/user/${currentUser}/games/${gameId}/make_move`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
            },
            body: JSON.stringify({
                question: question,
                answer: answer
            })
        })
        .catch(error => {

            console.log("catch")
            alert("Error saving changes", error);
        })
    }

    function updateCardsLeft(){
        fetch(`/user/${currentUser}/games/${gameId}/opponent_cards_left`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
            },
            body: JSON.stringify({
                player: nPlayer
            })
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                const cardsLeft = document?.getElementById('cards_left');
                console.log(data)
                cardsLeft.innerText = data.opponent_cards_left;
            } else {
                console.error(data)

                alert("Error update cards left");
            }
        })
        .catch(error => {
            console.error(error)
            alert("Error update cards left");

        });
    }
}
