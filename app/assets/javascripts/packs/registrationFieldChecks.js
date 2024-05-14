let loginUsernameValid = false;
let registerEmailValid = false;
let registerPasswordValid = false;

export function checkRegisterUsername() {
  const usernameInput = document.getElementById('username_register_field');
  if (usernameInput) {
    validateRegisterUsername(usernameInput);
    usernameInput.addEventListener('input', function() {
      validateRegisterUsername(usernameInput);
    });
  }
}

export function checkRegisterEmail() {
  const emailInput = document.getElementById('email_register_field');
  if (emailInput) {
    validateRegisterEmail(emailInput);
    emailInput.addEventListener('input', function () {
      validateRegisterEmail(emailInput);
    });
  }
}

export function checkRegisterPassword() {
  const passwordInput = document.getElementById('password_register_field');
  if (passwordInput) {
    passwordInput.addEventListener('input', function() {
      const password = passwordInput.value.trim();
      const registerPasswordValidityMessage = document.getElementById('passwordRegisterValidityMessage');
      if (password.length > 0) {
        registerPasswordValidityMessage.classList.add('hidden');
        //passwordInput.classList.add('border-none');
        //passwordInput.classList.remove('border', 'border-error-default', 'focus:border-error-default');
        registerPasswordValid = true;
        enableRegisterButton();
      } else {
        registerPasswordValidityMessage.classList.remove('hidden');
        //passwordInput.classList.remove('border-none');
        //passwordInput.classList.add('border', 'border-error-default', 'focus:border-error-default');
        registerPasswordValid = false;
        disableRegisterButton();
      }
    });
  }
}

function validateRegisterUsername(usernameInput) {
  const username = usernameInput.value.trim();
      if (username.length === 0) return;

      const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

      fetch('/users/check_username_availability', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': csrfToken
        },
        body: JSON.stringify({ username: username })
      })
        .then(response => { console.log(response); return response.json() })
        .then(data => {
        const messageElement = document.getElementById('usernameRegisterAvailabilityMessage');
        if (data.available) {
          messageElement.classList.add('hidden');
          //usernameInput.classList.add('border-none');
          //usernameInput.classList.remove('border', 'border-error-default', 'focus:border-error-default');
          loginUsernameValid = true;
          enableRegisterButton();
        } else {
          messageElement.classList.remove('hidden');
          //usernameInput.classList.remove('border-none');
          //usernameInput.classList.add('border', 'border-error-default', 'focus:border-error-default');
          loginUsernameValid = false;
          disableRegisterButton();
        }
      })
      .catch(error => {
        console.error('Error checking username availability:', error);
      });
}

export function validateRegisterEmail(emailInput) {
  const email = emailInput.value.trim();
  const emailRegisterValidityMessage = document.getElementById('emailRegisterValidityMessage');
  if (email.length === 0 || validateEmail(email)) {
    emailRegisterValidityMessage.classList.add('hidden');
    //emailInput.classList.add('border-none');
    //emailInput.classList.remove('border', 'border-error-default', 'focus:border-error-default');
    registerEmailValid = true;
    enableRegisterButton();
  } else {
    emailRegisterValidityMessage.classList.remove('hidden');
    //emailInput.classList.remove('border-none');
    //emailInput.classList.add('border', 'border-error-default', 'focus:border-error-default');
    registerEmailValid = false;
    disableRegisterButton();
  }

}

function validateEmail(email) {
  const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return regex.test(email);
}

function enableRegisterButton() {
  if (loginUsernameValid && registerEmailValid && registerPasswordValid) {
    const loginButton = document.getElementById('register_button');
    if (loginButton) {
      loginButton.disabled = false;
      loginButton.classList.add("transform", "hover:scale-x-110", "hover:scale-y-105", "transition", "duration-300", "ease-out")
    }
  }
}

function disableRegisterButton() {
  const loginButton = document.getElementById('register_button');
  if (loginButton) {
    loginButton.disabled = true;
      loginButton.classList.remove("transform", "hover:scale-x-110", "hover:scale-y-105", "transition", "duration-300", "ease-out")
  }
}
