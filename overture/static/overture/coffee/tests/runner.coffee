document.write """<div id=\"ember-testing-container\">
<div id=\"ember-testing\"></div>
</div>"""

# Allow us to see the app running inside the QUnit test runner
App.rootElement = "#ember-testing"

# Defer the readiness of the application, so we start when tests are ready
App.setupForTesting()

# Inject the test helper in the window's scope
App.injectTestHelpers()
