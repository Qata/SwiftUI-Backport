/// Courtesty of Karan Pal
/// https://www.swiftpal.io/articles/how-to-create-a-grid-view-in-swiftui-for-ios-13

#if canImport(SwiftUI)
import SwiftUI
import Algorithms

@available(macOS 10.15, iOS 13, watchOS 6, tvOS 13, *)
@available(macOS, deprecated: 11.0)
@available(iOS, deprecated: 14)
@available(watchOS, deprecated: 7)
@available(tvOS, deprecated: 14)
public struct EagerVGrid<Content: View, Item: Hashable>: View {
    @State var length = CGFloat.zero
    private let axis: Axis
    
    enum Axis {
        case columns(Int)
        case rows(Int)
        
        var amount: Int {
            switch self {
            case let .columns(value):
                return value
            case let .rows(value):
                return value
            }
        }
    }

    // Multi-dimensional array of your list. Modified as per rendering needs.
    private var items: [[Item]]

    // This block you specify in 'UIGrid' is stored here
    private let content: (Item) -> Content

    init(_ axis: Axis, list: [Item], @ViewBuilder content: @escaping (Item) -> Content) {
        self.axis = axis
        self.content = content
        self.items = list.chunks(ofCount: axis.amount).map(Array.init)
    }
    
    private func content(for item: Item) -> some View {
        content(item)
            .frame(width: length / CGFloat(axis.amount))
    }

    public var body: some View {
        Group {
            switch axis {
            case .columns:
                VStack {
                    ForEach(items, id: \.self) { item in
                        HStack {
                            ForEach(item, id: \.self, content: content(for:))
                        }
                    }
                }
            case .rows:
                HStack {
                    ForEach(items, id: \.self) { item in
                        VStack {
                            ForEach(item, id: \.self, content: content(for:))
                        }
                    }
                }
            }
        }
        .readSize {
            switch axis {
            case .rows:
                length = $0.height
            case .columns:
                length = $0.width
            }
        }
    }
}
#endif
