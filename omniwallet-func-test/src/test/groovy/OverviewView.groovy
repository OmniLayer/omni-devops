import geb.Page

/**
 * Overview Angular View
 *
 * Maybe this should be a Geb Module, but we're currently using <code>at</code> to verify
 * it is present and that is not supported in modules.
 */
class OverviewView extends Page {
    static content = {
        viewTitle { $("div[ng-controller='WalletOverviewController'] > .panel-default > .om-title").text() }
    }
    static at = { waitFor { viewTitle == "Overview" } }
}
