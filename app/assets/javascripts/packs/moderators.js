function deleteModerator(adminId, moderatorId) {
    const csrfToken = document?.querySelector('meta[name="csrf-token"]')?.content
    fetch(`/admin/${adminId}/delete_moderator`, {
        method: "POST",
        headers: {
            "Content-Type": "application/json",
            "X-CSRF-Token": csrfToken,
        },
        body: JSON.stringify({ user: { moderator_id: moderatorId } }), // Include current user's ID
    })
        .then(() => {
            location.reload();
        })
        .catch(() => {
            location.reload();
        });
}

export const moderators = () => {
    const searchInput = document.getElementById("moderators-search");
    const moderatorsList = document.getElementById("moderators-list");
    const adminPage = document.getElementById("admin-page");
    if(adminPage){
        const adminId = adminPage.dataset.adminId;
        searchInput &&
            searchInput.addEventListener("input", function () {
                const searchQuery = this.value.trim();
                getModeratorsList(adminId, searchQuery, moderatorsList);
            });

        // Add event listener for the "Send" link
        moderatorsList &&
        moderatorsList.addEventListener("click", function (event) {
                if (event.target.name === "delete") {
                    event.preventDefault();
                    const moderatorId = event.target.dataset.moderatorId;
                    deleteModerator(adminId, moderatorId);
                }
            });
    }
};

function getModeratorsList(adminId, searchQuery, userList) {
    fetch(`/admin/${adminId}/search_moderators/${searchQuery}`)
        .then((response) => response.json())
        .then((users) => {
            if (userList) {
                let usersListHtml = "";
                users &&
                    users.forEach((user) => {
                        usersListHtml += moderatorsLi(user);
                    });
                userList.innerHTML = usersListHtml;
            }
        })
        .catch((error) => {
            console.error("Error fetching search results:", error);
        });
}

const moderatorsLi = (user) => `
                  <div class="px-4 py-4 sm:px-6">
                    <div class="flex items-center justify-between">
                      <h3 class="text-lg leading-6 font-medium text-black dark:text-tertiary-default">${user.username}</h3>
                      <img name="delete" src="/images/friends/remove-icon.png" class="h-8 flex flex-end items-center space-x-3 px-2 rtl:space-x-reverse cursor-pointer transform hover:scale-x-110 hover:scale-y-105 transition duration-300 ease-out" alt="Delete friendship" data-moderator-id=${user.id} />
                      </div>
                  </div>
              `;