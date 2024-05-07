export const changeTheme = () => {


    // Apply theme on page load
    applyTheme();

    // Whenever the user explicitly chooses light mode
    document.getElementById('light-mode-button').addEventListener('click', function () {

        const autoModeButton = document.getElementById('auto-mode-button');
        const darkModeButton = document.getElementById('dark-mode-button');
        const lightModeButton = document.getElementById('light-mode-button');
        lightModeButton.classList.add("bg-tertiary-default", "text-white", "dark:text-black")
        lightModeButton.classList.remove("cursor-pointer","text-black", "dark:text-white", "transform", "hover:scale-x-110", "hover:scale-y-105", "transition", "duration-300", "ease-out")
        autoModeButton.classList.add("cursor-pointer","text-black", "dark:text-white", "transform", "hover:scale-x-110", "hover:scale-y-105", "transition", "duration-300", "ease-out")
        autoModeButton.classList.remove("bg-tertiary-default", "text-white", "dark:text-black")
        darkModeButton.classList.add("cursor-pointer","text-black", "dark:text-white", "transform", "hover:scale-x-110", "hover:scale-y-105", "transition", "duration-300", "ease-out")
        darkModeButton.classList.remove("bg-tertiary-default", "text-white", "dark:text-black")
        localStorage.theme = 'light';
        applyTheme();
    });

    // Whenever the user explicitly chooses dark mode
    document.getElementById('dark-mode-button').addEventListener('click', function () {
        const autoModeButton = document.getElementById('auto-mode-button');
        const darkModeButton = document.getElementById('dark-mode-button');
        const lightModeButton = document.getElementById('light-mode-button');
        darkModeButton.classList.add("bg-tertiary-default", "text-white", "dark:text-black")
        darkModeButton.classList.remove("cursor-pointer","text-black", "dark:text-white", "transform", "hover:scale-x-110", "hover:scale-y-105", "transition", "duration-300", "ease-out")
        autoModeButton.classList.add("cursor-pointer","text-black", "dark:text-white", "transform", "hover:scale-x-110", "hover:scale-y-105", "transition", "duration-300", "ease-out")
        autoModeButton.classList.remove("bg-tertiary-default", "text-white", "dark:text-black")
        lightModeButton.classList.add("cursor-pointer","text-black", "dark:text-white", "transform", "hover:scale-x-110", "hover:scale-y-105", "transition", "duration-300", "ease-out")
        lightModeButton.classList.remove("bg-tertiary-default", "text-white", "dark:text-black")
        localStorage.theme = 'dark';
        applyTheme();
    });

    // Whenever the user explicitly chooses to respect the OS preference
    document.getElementById('auto-mode-button').addEventListener('click', function () {
        const autoModeButton = document.getElementById('auto-mode-button');
        const darkModeButton = document.getElementById('dark-mode-button');
        const lightModeButton = document.getElementById('light-mode-button');
        autoModeButton.classList.add("bg-tertiary-default", "text-white", "dark:text-black")
        autoModeButton.classList.remove("cursor-pointer","text-black", "dark:text-white", "transform", "hover:scale-x-110", "hover:scale-y-105", "transition", "duration-300", "ease-out")
        darkModeButton.classList.add("cursor-pointer","text-black", "dark:text-white", "transform", "hover:scale-x-110", "hover:scale-y-105", "transition", "duration-300", "ease-out")
        darkModeButton.classList.remove("bg-tertiary-default", "text-white", "dark:text-black")
        lightModeButton.classList.add("cursor-pointer","text-black", "dark:text-white", "transform", "hover:scale-x-110", "hover:scale-y-105", "transition", "duration-300", "ease-out")
        lightModeButton.classList.remove("bg-tertiary-default", "text-white", "dark:text-black")
        localStorage.removeItem('theme');
        applyTheme();
    });
}
    // theme.js
const applyTheme = () => {
    if (localStorage.theme === 'dark' || (!('theme' in localStorage) && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
        document.documentElement.classList.add('dark');
    } else {
        document.documentElement.classList.remove('dark');
    }
};