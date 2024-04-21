
import { checkUsername, checkEmail } from "./fieldChecks.js"
import { login_or_registerFlip, setAlerts } from "./cssChanges.js"

export function startOnLoad() {
    if (window.location.hash === '#_=_') {
        history.replaceState(null, '', window.location.href.split('#')[0]);
    }
    checkUsername();
    checkEmail();
    login_or_registerFlip();
    setAlerts();
}
