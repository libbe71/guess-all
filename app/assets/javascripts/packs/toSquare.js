export function toSquareHome() {
    function toSquare(id) {
        const toSquare = document.getElementById(id);
        if (toSquare) {
            const parent = toSquare.parentNode;

            if (parent) {
                window.addEventListener("resize", () => {
                    
                    if(parent.clientHeight < parent.clientWidth)
                        toSquare.style.width = `${parent.clientHeight}px`;
                    else {
                        toSquare.style.width = `${parent.clientWidth}px`;
                    }
                });
                // Initial sizing
                initialSize(id);
            }
        }
    }

    function initialSize(id) {
        const toSquare = document.getElementById(id);
        if (toSquare) {
            const parent = toSquare.parentNode;
            if (parent.clientHeight < parent.clientWidth) {
                toSquare.style.width = `${parent.clientHeight}px`;
            } else {
                toSquare.style.width = `${parent.clientWidth}px`;
            }
        }
    }

    toSquare("toSquare1");
    toSquare("toSquare2");
    toSquare("toSquare3");
    toSquare("toSquare4");
    toSquare("toSquare5");

    const homepage = document.getElementById("homepage_desktop");
    if (homepage) {
        homepage.classList.remove("invisible");
    }

        // Create a MediaQueryList object
        var x = window.matchMedia("(min-width: 640px)")


        // Attach listener function on state changes
        x.addEventListener("change", function() {
            // Call listener function at run time
            if (x.matches) {
                initialSize("toSquare1");
                initialSize("toSquare2");
                initialSize("toSquare3");
                initialSize("toSquare4");
                
            }
        });

}
