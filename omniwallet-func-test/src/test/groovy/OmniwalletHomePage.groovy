import geb.Page

/**
 * Omniwallet Home Page
 */
class OmniwalletHomePage extends Page {
    static content = {
        loginLink { $("ul.nav li:nth-child(2) a") }
    }
    static at = { waitFor { title == "Omniwallet™ - The Next Generation Wallet" } }
    void login() {
        loginLink.click()
    }
}
