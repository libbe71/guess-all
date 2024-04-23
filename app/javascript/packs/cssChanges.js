export function login_or_registerFlip() {
    const toggleRegister = document.getElementById('toggle_register');
    const toggleLogin = document.getElementById('toggle_login');
    if (toggleRegister && toggleLogin) {
      toggleLogin.addEventListener('click', function () {
         handleFlip(toggleLogin,toggleRegister)
      });
      toggleRegister.addEventListener('click', function () {
         handleFlip(toggleLogin,toggleRegister)
      });
    }
}

function handleFlip(toggleLogin,toggleRegister) {
  
    const filpCard = document.getElementById('flipCard');
    toggleLogin.classList.toggle("hidden")
    toggleRegister.classList.toggle("hidden")
    filpCard.classList.toggle('flip');
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
