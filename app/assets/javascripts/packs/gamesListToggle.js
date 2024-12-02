function toggleGames() {
  const ongoingGames = document.getElementById('ongoing-games');
  const endedGames = document.getElementById('ended-games');
  const toggleButton = document.getElementById('toggle-button');

const currentLocale = document
  .querySelector('meta[name="locale"]')
  .getAttribute("content");
  if (ongoingGames.classList.contains('hidden')) {
  ongoingGames.classList.remove('hidden');
  endedGames.classList.add('hidden');
  if(currentLocale==="it")
    toggleButton.textContent = "Mostra partite terminate";
  else if (currentLocale==="en")
    toggleButton.textContent = 'Show Ended Games';

  } else {
  ongoingGames.classList.add('hidden');
  endedGames.classList.remove('hidden');
  if(currentLocale==="it")
    toggleButton.textContent = "Mostra partite in corso";
  else if (currentLocale==="en")
    toggleButton.textContent = 'Show Ongoing Games';
  }
}

export function toggleGamesEL(){
  const toggleButton = document.getElementById("toggle-button")
  if(toggleButton)
    toggleButton.addEventListener('click', ()=>toggleGames())
}