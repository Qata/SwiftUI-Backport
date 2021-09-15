/// Courtesty of Javier Nigro
/// https://swiftui-lab.com/backward-compatibility/

#if canImport(SwiftUI)
import SwiftUI

@available(macOS 10.15, iOS 13, watchOS 6, tvOS 13, *)
@available(macOS, deprecated: 11.0)
@available(iOS, deprecated: 14)
@available(watchOS, deprecated: 7)
@available(tvOS, deprecated: 14)
struct LazyHStack<Content> : View where Content : View {
    var alignment: VerticalAlignment = .center
    var spacing: CGFloat?
    let content: () -> Content
    
    var body: some View {
        if #available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *) {
            SwiftUI.LazyHStack(alignment: alignment, spacing: spacing, content: content)
        } else {
            // Fallback on earlier versions
            HStack(alignment: alignment, spacing: spacing, content: content)
        }
    }

    init(alignment: VerticalAlignment = .center, spacing: CGFloat? = nil, @ViewBuilder content: @escaping () -> Content) {
        self.alignment = alignment
        self.spacing = spacing
        self.content = content
    }
}
#endif
