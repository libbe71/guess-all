export function userDropDown() {
    const userButton = document.getElementById('desktop-user-button');
    const userDropdown = document.getElementById('desktop-user-dropdown');
    if (userButton && userDropdown) {
      userButton.addEventListener('click', function () {
         userDropdown.classList.toggle("hidden")
      });      
    }
}
