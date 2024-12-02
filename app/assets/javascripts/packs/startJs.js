
import { checkRegisterUsername, checkRegisterEmail, checkRegisterPassword } from "./registrationFieldChecks.js"
import { checkLoginIdentifier, checkLoginPassword } from "./loginFieldChecks.js"
import { login_or_registerFlip, setAlerts } from "./loginToggle.js"
import { userDropDown } from "./userDropDown.js"
import { toSquareHome } from "./toSquare.js"
import { changeTheme, applyTheme, autoTheme} from "./changeTheme.js"
import { logout } from "./logout.js"
import { friends, friendsSent, friendsReceived, gamesToStart, users } from "./friends.js"
import { toggleGamesEL} from "./gamesListToggle.js"

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
    changeTheme();
    logout();
    applyTheme();
    autoTheme();
    toSquareHome();
    friends();
    friendsSent();
    friendsReceived();
    gamesToStart();
    users();
    toggleGamesEL();
}
