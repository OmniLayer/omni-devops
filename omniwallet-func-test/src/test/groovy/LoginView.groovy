import geb.Page

/**
 * Login Angular View
 *
 * Maybe this should be a Geb Module, but we're currently using <code>at</code> to verify
 * it is present and that is not supported in modules.
 */
class LoginView extends Page {
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
