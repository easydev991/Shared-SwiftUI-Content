import PFVInterface
import SwiftUI

public struct GoodDemoViewProviderImp: GoodDemoViewProvider {
    public var demoView: some View {
        DemoView(number: 1)
    }
    
    public func makeDemoView() -> some View {
        DemoView(number: 2)
    }
    
    public init() {}
}
