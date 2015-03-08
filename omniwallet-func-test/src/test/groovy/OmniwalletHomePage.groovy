import geb.Page

/**
 * Omniwallet Home Page
 */
class OmniwalletHomePage extends Page {
    static url = "/"    // baseUrl is used for scheme, hostname, port
    static content = {
        loginLink { $("ul.nav li:nth-child(2) a") }
    }
    static at = { waitFor { title == "Omniwallet™ - The Next Generation Wallet" } }
    void login() {
        loginLink.click()
    }
}
