export function login_or_registerFlip() {
    const toggle = document.getElementById('toggle_log');

    toggle && toggle.addEventListener('click', function () {
        const filpCard = document.getElementById('flipCard');
        if (toggle.innerHTML === "Login")
            toggle.innerHTML = "Register"
        else
            toggle.innerHTML = "Login"
    
        filpCard.classList.toggle('flip');
    });
}

export function setAlerts() {
  const flashMessages = document.getElementById('flash-messages');
  const closeButton = document.getElementById('close-button');

  if (flashMessages) {
    setTimeout(function() {
      flashMessages.classList.add('hidden');
    }, 10000);
  }

  if (closeButton) {
    closeButton.addEventListener('click', function() {
      flashMessages.classList.add('hidden');
    });
  }
}
