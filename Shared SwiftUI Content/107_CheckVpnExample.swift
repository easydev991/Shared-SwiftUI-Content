import SwiftUI
import VpnChecker

struct CheckVpnExampleView: View {
    @State private var isVpnActive = false
    @Environment(\.scenePhase) private var phase
    private let vpnChecker = VpnChecker()
    
    var body: some View {
        Text("VPN активен: \(isVpnActive)")
            .onChange(of: phase) { newPhase in
                if newPhase == .active {
                    isVpnActive = vpnChecker.isVpnActive
                }
            }
    }
}

#Preview {
    CheckVpnExampleView()
}
