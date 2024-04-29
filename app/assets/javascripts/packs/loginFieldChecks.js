let loginIdentifierValid = false;
let loginPasswordValid = false;

export function checkLoginIdentifier() {
  const identifierInput = document.getElementById('identifier_login_field');
  if (identifierInput) {
    identifierInput.addEventListener('input', function() {
      const identifier = identifierInput.value.trim();
      const identifierLoginValidityMessage = document.getElementById('identifierLoginValidityMessage');
      if (identifierLoginValidityMessage && identifier.length > 0) {
        identifierLoginValidityMessage.classList.add('hidden');
        //identifierInput.classList.add('border-none');
        //identifierInput.classList.remove('border', 'border-error-default', 'focus:border-error-default');
        loginIdentifierValid = true;
        enableLoginButton();
      } else {
        identifierLoginValidityMessage.classList.remove('hidden');
        //identifierInput.classList.remove('border-none');
        //identifierInput.classList.add('border', 'border-error-default', 'focus:border-error-default');
        loginIdentifierValid = false;
        disableLoginButton();
      }
    });
  }
}

export function checkLoginPassword() {
  const passwordInput = document.getElementById('password_login_field');
  if (passwordInput) {
    passwordInput.addEventListener('input', function() {
      const password = passwordInput.value.trim();
      const passwordLoginValidityMessage = document.getElementById('passwordLoginValidityMessage');
      if (password.length > 0) {
        passwordLoginValidityMessage.classList.add('hidden');
        //passwordInput.classList.add('border-none');
        //passwordInput.classList.remove('border', 'border-error-default', 'focus:border-error-default');
        loginPasswordValid = true;
        enableLoginButton();
      } else {
        passwordLoginValidityMessage.classList.remove('hidden');
        //passwordInput.classList.remove('border-none');
        //passwordInput.classList.add('border', 'border-error-default', 'focus:border-error-default');
        loginPasswordValid = false;
        disableLoginButton();
      }
    });
  }
}

function enableLoginButton() {
  if (loginIdentifierValid && loginPasswordValid) {
    const loginButton = document.getElementById('login_button');
    if (loginButton) {
      loginButton.disabled = false;
      loginButton.classList.add("transform", "hover:scale-x-110", "hover:scale-y-105", "transition", "duration-300", "ease-out")
    }
  }
}

function disableLoginButton() {
  const loginButton = document.getElementById('login_button');
  if (loginButton) {
    loginButton.disabled = true;
    loginButton.classList.remove("transform", "hover:scale-x-110", "hover:scale-y-105", "transition", "duration-300", "ease-out")
  }
}
