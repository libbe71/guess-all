export const friends = () => {
    const searchInput = document.getElementById("users-search-friends");
    const userList = document.getElementById("users-list");
    searchInput &&
        searchInput.addEventListener("input", function () {
            const searchQuery = this.value.trim();
            getUsersList(searchQuery, userList, "search_friends");
        });

    // Add event listener for the "Send" link
    userList &&
        userList.addEventListener("click", function (event) {
            if (event.target.name === "delete") {
                event.preventDefault();
                const currentUser = userList.dataset.currentUser
                const userId = event.target.dataset.userId;
                deleteFriend(currentUser, userId);
            }
        });
};
export function friendsSent() {
    const searchInput = document.getElementById("users-search-sent");
    const userList = document.getElementById("users-list");
    searchInput && userList &&
        searchInput.addEventListener("input", function () {
            const searchQuery = this.value.trim();
            const currentUser = userList.dataset.currentUser
            getUsersList(currentUser, searchQuery, userList, "search_sent");
        });
}
export function friendsReceived() {
    const searchInput = document.getElementById("users-search-received");
    const userList = document.getElementById("users-list");

    searchInput && userList &&
        searchInput.addEventListener("input", function () {
            const searchQuery = this.value.trim();
            const currentUser = userList.dataset.currentUser
            getUsersList(currentUser, searchQuery, userList, "search_received");
        });

    // Add event listener for the "Send" link
    userList &&
        userList.addEventListener("click", function (event) {
            if (event.target.name === "delete") {
                event.preventDefault();
                const userId = event.target.dataset.userId;
                const currentUser = userList.dataset.currentUser
                deleteFriend(currentUser, userId);
            } else if (event.target.name === "accept") {
                event.preventDefault();
                const userId = event.target.dataset.userId;
                const currentUser = userList.dataset.currentUser
                acceptFriend(currentUser, userId);
            }
        });
}
export function users() {
    const searchInput = document.getElementById("users-search");
    const userList = document.getElementById("users-list");

    searchInput && userList &&
        searchInput.addEventListener("input", function () {
            const searchQuery = this.value.trim();
            const currentUser = userList.dataset.currentUser
            getUsersList(currentUser, searchQuery, userList, "search_users");
        });

    // Add event listener for the "Send" link
    userList &&
        userList.addEventListener("click", function (event) {
            if (event.target.name === "send-invite") {
                event.preventDefault();
                const userId = event.target.dataset.userId;
                const searchQuery = searchInput.value ?? "";
                const currentUser = userList.dataset.currentUser
                sendFriendRequest(currentUser, userId, searchQuery, userList);
            }
        });
}

export const gamesToStart = () => {
    const userList = document.getElementById('to-Start-list');

    if (userList) {
        const currentUser = userList.dataset.currentUser
        fetch(`/user/${currentUser}/friends/search_friends/`)
        .then(response =>  response.json() )
        .then(users => {
            let usersListHtml = "";
            users && users.forEach(user => {
                usersListHtml += gameToStartLi(user);
            });
            userList.innerHTML = usersListHtml;

            // Attach event listeners to the "Start" buttons after rendering the users
            document.querySelectorAll('button[name="start-new-game"]').forEach(button => {
                button.addEventListener('click', () => {
                    const friendId = button.getAttribute('data-user-id');
                    startNewGame(currentUser, friendId); // Pass the friend ID to create the game
                });
            });
            })
            .catch(error => {
                console.error('Error fetching search results:', error);
            });
    }
}

const requestSentTranslation = () => {
    const currentLocale = document
        .querySelector('meta[name="locale"]')
        .getAttribute("content");
    switch (currentLocale) {
        case "it":
            return "Inviata";
        case "en":
            return "Sent";
        default:
            return "Inviata";
    }
};
const requestReceivedTranslation = () => {
    const currentLocale = document
        .querySelector('meta[name="locale"]')
        .getAttribute("content");
    switch (currentLocale) {
        case "it":
            return "Invia richiesta di amicizia";
        case "en":
            return "Send friend's request";
        default:
            return "Invia richiesta di amicizia";
    }
};
const receivedLi = (user) => `
                <div class="px-4 py-4 sm:px-6">
                  <div class="flex items-center justify-between">
                    <h3 class="text-lg leading-6 font-medium text-black dark:text-tertiary-default">${user.username}</h3>
                    <img name="accept" src="/images/friends/accept-icon.png" class="h-8 flex flex-end items-center transform hover:scale-x-110 hover:scale-y-105 transition duration-300 ease-out cursor-pointer" alt="Accept friend" data-user-id=${user.id} />
                    <img name="delete" src="/images/friends/remove-icon.png" class="h-8 flex flex-end items-center transform hover:scale-x-110 hover:scale-y-105 transition duration-300 ease-out cursor-pointer" alt="Refuse friend" data-user-id=${user.id} />
                  </div>
                </div>
              `;
const friendsLi = (user) => `
                  <div class="px-4 py-4 sm:px-6">
                    <div class="flex items-center justify-between">
                      <h3 class="text-lg leading-6 font-medium text-black dark:text-tertiary-default">${user.username}</h3>
                      <img name="delete" src="/images/friends/remove-icon.png" class="h-8 flex flex-end items-center space-x-3 px-2 rtl:space-x-reverse cursor-pointer transform hover:scale-x-110 hover:scale-y-105 transition duration-300 ease-out" alt="Delete friendship" data-user-id=${user.id} />
                      </div>
                  </div>
              `;
const sentLi = (user) => `
                  <div class="px-4 py-4 sm:px-6">
                    <div class="flex items-center justify-between">
                      <h3 class="text-lg leading-6 font-medium text-black dark:text-tertiary-default">${
                          user.username
                      }</h3>
                      <div class="flex items-center justify-start">
                        <p class="text-sm font-medium text-balck dark:text-tertiary-default"><span class="text-green-600">${requestSentTranslation()}</span></p>
                      </div>
                    </div>
                  </div>
              `;
const usersLi = (user) => `
                  <div class="px-4 py-4 sm:px-6">
                    <div class="flex items-center justify-between">
                      <h3 class="text-lg leading-6 font-medium text-black dark:text-tertiary-default">${
                          user.username
                      }</h3>
                      
                    </div>
                    <div class="mt-4 flex items-center justify-start">
                      <Button name=${"send-invite"} class="font-medium text-tertiary-default transform hover:scale-x-110 hover:scale-y-105 transition duration-300 ease-out" data-user-id="${
    user.id
}">${requestReceivedTranslation()}</Button>
                    </div>
                  </div>
              `;


const gameToStartLi = (user) => `
    <div class="px-4 py-2 sm:px-6">
        <div class="flex items-center justify-between">
            <h3 class="text-lg leading-6 font-medium text-black dark:text-tertiary-default">${user.username}</h3>
            <button name="start-new-game" class="h-12 flex flex-end items-center text-secondary-default dark:text-tertiary-default rounded-full font-bold border-2 border-secondary-default dark:border-tertiary-default space-x-3 px-2 rtl:space-x-reverse cursor-pointer transform hover:scale-x-110 hover:scale-y-105 transition duration-300 ease-out" alt="Start new game" data-user-id=${user.id} >
                Start
            </button>
        </div>
    </div>
`;

function deleteFriend(currentUser, userId) {
    const csrfToken = document?.querySelector('meta[name="csrf-token"]')?.content
    fetch(`/user/${currentUser}/friends/delete`, {
        method: "POST",
        headers: {
            "Content-Type": "application/json",
            "X-CSRF-Token": csrfToken,
        },
        body: JSON.stringify({ friend: { friend_id: userId } }), // Include current user's ID
    })
        .then(() => {
            location.reload();
        })
        .catch(() => {
            location.reload();
        });
}
function getUsersList(currentUser, searchQuery, userList, path) {
    if (searchQuery === "" && path === "search_users") {
        if (userList) userList.innerHTML = "";
        return;
    }
    fetch(`/user/${currentUser}/friends/${path}/${searchQuery}`)
        .then((response) => response.json())
        .then((users) => {
            if (userList) {
                let usersListHtml = "";
                users &&
                    users.forEach((user) => {
                        switch (path) {
                            case "search_users":
                                //if(searchQuery !== "")
                                usersListHtml += usersLi(user);
                                break;
                            case "search_sent":
                                usersListHtml += sentLi(user);
                                break;
                            case "search_received":
                                usersListHtml += receivedLi(user);
                                break;
                            case "search_friends":
                                usersListHtml += friendsLi(user);
                                break;
                        }
                    });
                userList.innerHTML = usersListHtml;
            }
        })
        .catch((error) => {
            console.error("Error fetching search results:", error);
        });
}
function sendFriendRequest(currentUser, userId) {
    const csrfToken = document?.querySelector('meta[name="csrf-token"]')?.content
    fetch(`/user/${currentUser}/friends/create`, {
        method: "POST",
        headers: {
            "Content-Type": "application/json",
            "X-CSRF-Token": csrfToken,
        },
        body: JSON.stringify({ friend: { friend_id: userId } }), // Include current user's ID
    })
        .then(() => {
            location.reload();
        })
        .catch(() => {
            location.reload();
        });
}
function acceptFriend(currentUser, userId) {
    const csrfToken = document?.querySelector('meta[name="csrf-token"]')?.content
    fetch(`/user/${currentUser}/friends/accept`, {
        method: "PATCH",
        headers: {
            "Content-Type": "application/json",
            "X-CSRF-Token": csrfToken,
        },
        body: JSON.stringify({ friend: { friend_id: userId } }), // Include current user's ID
    })
        .then(() => {
            location.reload();
        })
        .catch(() => {
            location.reload();
        });
}


// Function to send the AJAX request to create a new game
function startNewGame(currentUser, friendId) {
  fetch(`/user/${currentUser}/games/new`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'X-CSRF-Token': document?.querySelector('meta[name="csrf-token"]')?.content
    },
    body: JSON.stringify({ game: { player2_id: friendId } }) // Send friend ID as player2
  })
  .then(response => response.json())
  .then(data => {
    if (data.success) {
        const fullURL = window.location.href
        const urlSplitted = fullURL?.split("/")
        const urlGames = urlSplitted.slice(0, urlSplitted.length-1).join("/")
        window.location.href = `${urlGames}/${data.game_id}/select_character/1`; // Redirect to the game show page
    } else {
      alert('Unable to start the game');
    }
  })
  .catch(error => {
    console.error('Error starting the game:', error);
  });
}