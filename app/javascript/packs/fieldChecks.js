
export function checkUsername() {

    const usernameInput = document.getElementById('identifier_input_field');
    // Username availability check
    if(usernameInput){
      usernameInput.addEventListener('input', function() {
        const username = usernameInput.value.trim();
        if (username.length === 0) return; // Skip if the username is empty

        const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

        fetch('/users/check_username_availability', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'X-CSRF-Token': csrfToken
          },
          body: JSON.stringify({ username: username })
        })
        .then(response => {
           response.json()
            .then(data => {
              const messageElement = document.getElementById('usernameAvailabilityMessage');
              if (data.available) {
                messageElement.classList.add('hidden');
                usernameInput.classList.add('border-none');
                usernameInput.classList.remove('border');
                usernameInput.classList.remove('border-error-default');
                usernameInput.classList.remove('focus:border-error-default');
              } else {
                messageElement.classList.remove('hidden');
                usernameInput.classList.remove('border-none');
                usernameInput.classList.add('border');
                usernameInput.classList.add('border-error-default');
                usernameInput.classList.add('focus:border-error-default');
                
              }
            })
        })
        .catch(error => {
          console.error('Error checking username availability:', error);
        });
      });
    }

}

export function checkEmail() {

    const emailInput = document.getElementById('email_input_field');

    if(emailInput) {
        emailInput.addEventListener('blur', function() {
            const email = emailInput.value.trim();

            const emailValidityMessage = document.getElementById('emailValidityMessage');

            if (email.length === 0 || validateEmail(email)) {
            emailValidityMessage.classList.add('hidden');
            emailInput.classList.add('border-none');
            emailInput.classList.remove('border');
            emailInput.classList.remove('border-error-default');
            emailInput.classList.remove('focus:border-error-default');
            } else {
            emailValidityMessage.classList.remove('hidden');
            emailInput.classList.remove('border-none');
            emailInput.classList.add('border');
            emailInput.classList.add('border-error-default');
            emailInput.classList.add('focus:border-error-default');
            }
        });
    }
}

function validateEmail(email) {
    const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return regex.test(email);
}
