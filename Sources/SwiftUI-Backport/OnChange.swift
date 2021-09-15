/// Courtesty of Jérôme Alves
/// https://gist.github.com/jegnux/c3aee7957f6c372bf31a46c893a6e2a2

#if canImport(SwiftUI)
import SwiftUI
import Combine

@available(macOS 10.15, iOS 13, watchOS 6, tvOS 13, *)
@available(macOS, deprecated: 11.0)
@available(iOS, deprecated: 14)
@available(watchOS, deprecated: 7)
@available(tvOS, deprecated: 14)
public struct ChangeObserver<V: Equatable>: ViewModifier {
    public init(newValue: V, action: @escaping (V) -> Void) {
        self.newValue = newValue
        self.newAction = action
    }

    private typealias Action = (V) -> Void

    private let newValue: V
    private let newAction: Action

    @State private var state: (V, Action)?

    public func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(Just(newValue)) { newValue in
                if let (currentValue, action) = state, newValue != currentValue {
                    action(newValue)
                }
                state = (newValue, newAction)
            }
    }
}

@available(macOS 10.15, iOS 13, watchOS 6, tvOS 13, *)
@available(macOS, deprecated: 11.0)
@available(iOS, deprecated: 14)
@available(watchOS, deprecated: 7)
@available(tvOS, deprecated: 14)
public extension View {
    @_disfavoredOverload
    @ViewBuilder
    func onChange<V>(of value: V, perform action: @escaping (V) -> Void) -> some View where V: Equatable {
        modifier(ChangeObserver(newValue: value, action: action))
    }
}
#endif
