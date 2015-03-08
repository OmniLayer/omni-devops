import geb.Page

/**
 * TODO: Convert from Page to Module
 */
class LoginModule extends Page {
    static content = {
        loginForm { $("form[ng-submit='open(login)']") }
        modalTitle { $("body > .modal > .modal-dialog h3").text() }
        walletIdInput { $("#inputUUID") }
        passwordInput { $("#inputPassword") }
        openWalletSubmit { loginForm.find(type: "submit") }

    }
    static at = { waitFor { modalTitle == "Login" } }

    void login(walletid, password) {
        walletIdInput = walletid
        passwordInput = password
        openWalletSubmit.click()
    }
}
