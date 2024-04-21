
import { checkUsername, checkEmail } from "./fieldChecks.js"
import { login_or_registerFlip, setAlerts } from "./cssChanges.js"

export function startOnLoad() {
    checkUsername();
    checkEmail();
    login_or_registerFlip();
    setAlerts();
}

