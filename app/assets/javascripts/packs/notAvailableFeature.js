function showNotAvailableFeaturePopUp() {
    const responsePopUp = document.getElementById('responsePopUp');
    const responseText = document.getElementById('responseText');
    const closePopUpButton = document.getElementById('closePopUp');

    responsePopUp.classList.remove('hidden'); // Show the pop-up

    // Add click event for the close button
    closePopUpButton.addEventListener('click', () => {
        responsePopUp.classList.add('hidden'); // Hide the pop-up
    });
}
export function notAvailableFeatureEL () {
    const toSquare2 = document.getElementById('toSquare2');
    const toSquare4 = document.getElementById('toSquare4');
    const mobileSets = document.getElementById('mobileSets');
    const mobileShop = document.getElementById('mobileShop');
    if(toSquare2) toSquare2.addEventListener("click", () => {showNotAvailableFeaturePopUp()})
    if(toSquare4) toSquare4.addEventListener("click", () => {showNotAvailableFeaturePopUp()})
    if(mobileSets) mobileSets.addEventListener("click", () => {showNotAvailableFeaturePopUp()})
    if(mobileShop) mobileShop.addEventListener("click", () => {showNotAvailableFeaturePopUp()})
}