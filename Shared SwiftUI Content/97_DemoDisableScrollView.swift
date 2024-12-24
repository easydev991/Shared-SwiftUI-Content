import SwiftUI

private struct ReusableButton: View {
  @Binding var isScrollEnabled: Bool
  
  var body: some View {
    Button(isScrollEnabled ? "Выключить скролл" : "Включить скролл") {
      isScrollEnabled.toggle()
    }
    .font(.title.bold())
  }
}

private struct ReusableScrollView: View {
  let axisSet: Axis.Set
  @Binding var isScrollEnabled: Bool
  
  var body: some View {
    ScrollView(axisSet) {
      VStack {
        Rectangle()
          .frame(width: 100, height: 100)
        ReusableButton(isScrollEnabled: $isScrollEnabled)
        Rectangle()
          .frame(width: 100, height: 100)
      }
    }
  }
}

struct DemoDisableScrollView1: View {
  @State private var isScrollEnabled = true
  private var scrollAxisSet: Axis.Set {
    isScrollEnabled ? .vertical : []
  }
  
  var body: some View {
    ReusableScrollView(
      axisSet: scrollAxisSet,
      isScrollEnabled: $isScrollEnabled
    )
  }
}

struct DemoDisableScrollView2: View {
  @State private var isScrollEnabled = true
  
  var body: some View {
    if #available(iOS 16.0, *) {
      scrollView
        .scrollDisabled(!isScrollEnabled)
    } else {
      scrollView
        .contentShape(.rect)
        .gesture(isScrollEnabled ? nil : DragGesture())
    }
  }
  
  private var scrollView: some View {
    ReusableScrollView(
      axisSet: .vertical,
      isScrollEnabled: $isScrollEnabled
    )
  }
}

struct DemoDisableTabView: View {
  private enum Item: String, CaseIterable, Identifiable, Hashable {
    case one, two, three
    var id: String { rawValue }
  }
  
  @State private var isScrollEnabled = true
  
  var body: some View {
    TabView {
      ForEach(Item.allCases) { tab in
        VStack(spacing: 20) {
          Text("Tab \(tab.rawValue)").font(.title2.bold())
          ReusableButton(isScrollEnabled: $isScrollEnabled)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .tag(tab.id)
      }
      .contentShape(.rect)
      .gesture(isScrollEnabled ? nil : DragGesture())
    }
    .tabViewStyle(.page(indexDisplayMode: .never))
    .indexViewStyle(.page(backgroundDisplayMode: .never))
  }
}

#Preview("Axis.Set") {
  DemoDisableScrollView1()
}

#Preview("ScrollDisabled / Gesture") {
  DemoDisableScrollView2()
}

#Preview("TabView") {
  DemoDisableTabView()
}
