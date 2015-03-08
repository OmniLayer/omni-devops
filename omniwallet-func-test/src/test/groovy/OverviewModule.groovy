import geb.Page

/**
 * TODO: Convert from Page to Module
 */
class OverviewModule extends Page {
    static content = {
        viewTitle { $("div[ng-controller='WalletOverviewController'] > .panel-default > .om-title").text() }
    }
    static at = { waitFor { viewTitle == "Overview" } }
}
