
import { checkRegisterUsername, checkRegisterEmail, checkRegisterPassword } from "./registrationFieldChecks.js"
import { checkLoginIdentifier, checkLoginPassword } from "./loginFieldChecks.js"
import { login_or_registerFlip, setAlerts } from "./loginToggle.js"
import { userDropDown } from "./userDropDown.js"
import { toSquareHome } from "./toSquare.js"

export function startOnLoad() {
    if (window.location.hash === '#_=_') {
        history.replaceState(null, '', window.location.href.split('#')[0]);
    }
    checkRegisterUsername();
    checkRegisterEmail();
    checkRegisterPassword();
    checkLoginIdentifier();
    checkLoginPassword();
    login_or_registerFlip();
    userDropDown()
    setAlerts();

    toSquareHome()
}
