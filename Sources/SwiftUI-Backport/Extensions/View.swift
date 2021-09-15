import SwiftUI

@available(macOS 10.15, iOS 13, watchOS 6, tvOS 13, *)
public extension View {
    func hidden(_ shouldHide: Bool) -> some View {
        disabled(shouldHide)
            .opacity(shouldHide ? 0 : 1)
    }
}
