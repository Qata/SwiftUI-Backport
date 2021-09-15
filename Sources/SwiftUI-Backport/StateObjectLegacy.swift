/// Courtesy of Alexander Kulabukhov
/// https://stackoverflow.com/questions/66426228/stateobject-on-ios-13

import SwiftUI

@available(*, message: "Use @StateObject")
@available(macOS, introduced: 10.15, deprecated: 11.0)
@available(iOS, introduced: 13, deprecated: 14)
@available(watchOS, introduced: 6, deprecated: 7)
@available(tvOS, introduced: 13, deprecated: 14)
struct StateObjectLegacy<V: View, ViewModel: ObservableObject>: View {
    private let contentView: V
    @State private var contentViewModel: ViewModel

    init(viewModel: @autoclosure () -> ViewModel, @ViewBuilder contentView: () -> V) {
        self._contentViewModel = State(initialValue: viewModel())
        self.contentView = contentView()
    }

    var body: some View {
        contentView
            .environmentObject(contentViewModel)
    }
}

@available(*, message: "Use @StateObject")
@available(macOS, introduced: 10.15, deprecated: 11.0)
@available(iOS, introduced: 13, deprecated: 14)
@available(watchOS, introduced: 6, deprecated: 7)
@available(tvOS, introduced: 13, deprecated: 14)
struct StateObjectLegacyModifier<ViewModel: ObservableObject>: ViewModifier {
    var viewModel: () -> ViewModel

    func body(content: Content) -> some View {
        StateObjectLegacy(viewModel: viewModel()) {
            content
        }
    }
}

@available(*, message: "Use @StateObject")
@available(macOS, introduced: 10.15, deprecated: 11.0)
@available(iOS, introduced: 13, deprecated: 14)
@available(watchOS, introduced: 6, deprecated: 7)
@available(tvOS, introduced: 13, deprecated: 14)
public extension View {
    func stateObjectLegacy<ViewModel: ObservableObject>(
        _ viewModel: @escaping @autoclosure () -> ViewModel
    ) -> some View {
        modifier(StateObjectLegacyModifier(viewModel: viewModel))
    }
}
