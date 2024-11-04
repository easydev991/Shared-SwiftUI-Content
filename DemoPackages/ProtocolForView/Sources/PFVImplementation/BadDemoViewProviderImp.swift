import PFVInterface
import SwiftUI

public struct BadDemoViewProviderImp: BadDemoViewProvider {
    public var demoView: AnyView {
        AnyView(DemoView(number: 1))
    }
    
    public func makeDemoView() -> AnyView {
        AnyView(DemoView(number: 2))
    }
    
    public func makeDemoView2() -> any View {
        DemoView(number: 3)
    }
    
    public init() {}
}
