/// Courtesy of Federico Zanetello
/// https://www.fivestars.blog/articles/swiftui-share-layout-information/

#if canImport(SwiftUI)
import SwiftUI

@available(iOS 13, watchOS 6, tvOS 13, *)
public struct SizePreferenceKey: PreferenceKey {
    public static var defaultValue: CGSize = .zero
    public static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}

@available(iOS 13, watchOS 6, tvOS 13, *)
public struct SafeAreaInsetsPreferenceKey: PreferenceKey {
    public static var defaultValue: EdgeInsets = .init()
    public static func reduce(value: inout EdgeInsets, nextValue: () -> EdgeInsets) {}
}

@available(macOS 10.15, iOS 13, watchOS 6, tvOS 13, *)
public extension View {
    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }

    func readSafeAreaInsets(onChange: @escaping (EdgeInsets) -> Void) -> some View {
        background(
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(key: SafeAreaInsetsPreferenceKey.self, value: geometryProxy.safeAreaInsets)
            }
        )
        .onPreferenceChange(SafeAreaInsetsPreferenceKey.self, perform: onChange)
    }
}
#endif
