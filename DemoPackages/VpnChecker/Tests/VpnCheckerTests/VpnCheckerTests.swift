import Testing
@testable import VpnChecker

struct VpnCheckerTests {
    @Test
    func isVpnInactiveWithoutScopedKeys() {
        let mockProvider = MockProxySettingsProvider(keys: nil)
        let vpnChecker = VpnChecker(proxySettingsProvider: mockProvider)
        #expect(!vpnChecker.isVpnActive)
    }
    
    @Test
    func isVpnInactiveWithEmptyScopedKeys() {
        let mockProvider = MockProxySettingsProvider(keys: [])
        let vpnChecker = VpnChecker(proxySettingsProvider: mockProvider)
        #expect(!vpnChecker.isVpnActive)
    }

    @Test
    func isVpnInactiveWithNonVpnKeys() {
        let mockProvider = MockProxySettingsProvider(keys: ["en0", "wi0"])
        let vpnChecker = VpnChecker(proxySettingsProvider: mockProvider)
        #expect(!vpnChecker.isVpnActive)
    }
    
    @Test
    func isVpnActiveWithScopedKeys() {
        let mockProvider = MockProxySettingsProvider(keys: ["tap0", "en0"])
        let vpnChecker = VpnChecker(proxySettingsProvider: mockProvider)
        #expect(vpnChecker.isVpnActive)
    }

    @Test
    func isVpnActiveWithMultipleScopedKeys() {
        let mockProvider = MockProxySettingsProvider(keys: ["tun0", "en0", "utun1"])
        let vpnChecker = VpnChecker(proxySettingsProvider: mockProvider)
        #expect(vpnChecker.isVpnActive)
    }
}

private struct MockProxySettingsProvider: ProxySettingsProvider {
    let scopedProxyKeys: [String]?
    
    init(keys: [String]?) {
        scopedProxyKeys = keys
    }
}
