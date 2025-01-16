const setWinnerEL = (moderatorId, gameId, playerId) =>{
    fetch(`/moderator/${moderatorId}/games/${gameId}/set_winner/${playerId}`, {
        method: 'PATCH',
        headers: {
            'Content-Type': 'application/json',
            'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
        }
    })
    .then(response => response.json())
    .then(data => {
        if(data.success)
            window.location.reload()
    })
    .catch(error => {
        alert("Error setting winner", error); 
    });
}

export const setGameWinner = () =>{
    const buttons = document.getElementsByName("set-winner");
    buttons.forEach(e => {
        const moderatorId = e.dataset.moderatorId
        const gameId = e.dataset.gameId
        const playerId = e.dataset.playerId

        e.addEventListener("click", () => { setWinnerEL(moderatorId, gameId, playerId) });
    });
}