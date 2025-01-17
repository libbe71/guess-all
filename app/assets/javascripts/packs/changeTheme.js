export const changeTheme = () => {

    const autoModeButton = document.getElementById('auto-mode-button');
    const darkModeButton = document.getElementById('dark-mode-button');
    const lightModeButton = document.getElementById('light-mode-button');
    const themeField = document.getElementById("theme-field");


    // Apply theme on page load
    applyTheme();

    const selected = ["bg-tertiary-default", "text-white", "dark:text-black"]
    const notSelected = ["text-black", "dark:text-tertiary-default", "cursor-pointer", "transform", "hover:scale-x-110", "hover:scale-y-105", "transition", "duration-300", "ease-out"]
    // Whenever the user explicitly chooses light mode
    lightModeButton && lightModeButton.addEventListener('click', function () {
        themeField.value = "light";
        lightModeButton.classList.add(...selected)
        lightModeButton.classList.remove(...notSelected)
        
        autoModeButton.classList.add(...notSelected)
        autoModeButton.classList.remove(...selected)
        
        darkModeButton.classList.add(...notSelected)
        darkModeButton.classList.remove(...selected)
        localStorage.theme = 'light';
        applyTheme();

    });

    // Whenever the user explicitly chooses dark mode
    darkModeButton && darkModeButton.addEventListener('click', function () {
        themeField.value = "dark";
        darkModeButton.classList.add(...selected)
        darkModeButton.classList.remove(...notSelected)
        
        autoModeButton.classList.add(...notSelected)
        autoModeButton.classList.remove(...selected)
        
        lightModeButton.classList.add(...notSelected)
        lightModeButton.classList.remove(...selected)
        localStorage.theme = 'dark';
        applyTheme()
    });

    // Whenever the user explicitly chooses to respect the OS preference
    autoModeButton && autoModeButton.addEventListener('click', function () {
        themeField.value = "auto";
        autoModeButton.classList.add(...selected)
        autoModeButton.classList.remove(...notSelected)

        darkModeButton.classList.add(...notSelected)
        darkModeButton.classList.remove(...selected)
        
        lightModeButton.classList.add(...notSelected)
        lightModeButton.classList.remove(...selected)
        localStorage.removeItem('theme');
        applyTheme();
    });
}
export const applyTheme = () => {
    const html = document.getElementById("html");
    if (localStorage.theme === 'dark') {
        html && html.classList.remove('light', 'hidden');
        html && html.classList.add('dark');
        updateSettings("dark")
    } else if (localStorage.theme === 'light') {
        html && html.classList.add('light');
        html && html.classList.remove('dark', 'hidden');
        updateSettings("light")
    } else {
        autoTheme();
        updateSettings(null)
    }
};

export const autoTheme = () => {
    const html = document.getElementById('html');
    
    const autoDarkThemeMedia = window.matchMedia('(prefers-color-scheme: dark)');
    const autoLightThemeMedia = window.matchMedia('(prefers-color-scheme: light)');
    
    const applyTheme = () => {
        if (!localStorage.getItem("theme") && autoDarkThemeMedia.matches) {
            html.classList.remove('light', 'hidden');
            html.classList.add('dark');
        } else if (!localStorage.getItem("theme") && autoLightThemeMedia.matches) {
            html.classList.add('light');
            html.classList.remove('dark', 'hidden');
        }
    };

    applyTheme();

    autoDarkThemeMedia.addEventListener("change", applyTheme);
    autoLightThemeMedia.addEventListener("change", applyTheme);
};

function updateSettings(theme) {
    const form = document.getElementById('form-theme')
    const field = document.getElementById('theme-field')
    if(field)
        field.value = theme;
    
    // Submit the form automatically
   form && form.submit();
}