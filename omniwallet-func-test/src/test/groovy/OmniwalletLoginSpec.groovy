import geb.spock.GebReportingSpec

class OmniwalletLoginSpec extends GebReportingSpec {

    // Warning: Don't store any coins or assets in this wallet!
    def walletid = '98da92d3-871a-485c-fa5f-01beb4181c9d'
    def password = 'Geb4Fun8'

    def "can login to Omniwallet"() {
        when:
        // Load the page
        to OmniwalletHomePage

        then:
        // make sure we actually got to the page
        at OmniwalletHomePage

        when:
        // Click Login
        login()

        then:
        // Login form is displayed
        at LoginView

        when:
        // Login to wallet
        login(walletid, password)

        then:
        // Overview view is displayed
        at OverviewView
   }
}

