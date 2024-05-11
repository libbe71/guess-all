export const logout = () => {
    const desktop = document.getElementById("logout-desktop");
    const mobile = document.getElementById("logout-mobile");

    desktop && desktop.addEventListener("click", () => {
        localStorage.removeItem("theme");
    })
    mobile && mobile.addEventListener("click", () => {
        localStorage.removeItem("theme");
    })

};