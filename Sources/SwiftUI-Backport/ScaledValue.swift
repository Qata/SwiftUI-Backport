#if canImport(SwiftUI) && !os(macOS)
import SwiftUI

public protocol Scalable {
    func scaled(with transform: (CGFloat) -> CGFloat) -> Self
}

/// A dynamic property that scales a numeric value.
@available(iOS 13, watchOS 6, tvOS 13, *)
@propertyWrapper
public struct Scaled<Value: Scalable>: DynamicProperty {
    @Environment(\.sizeCategory) var sizeCategory
    private let baseValue: Value
    private let metrics: UIFontMetrics
    private var traits: UITraitCollection {
        .init(traitsFrom: [
            .init(
                preferredContentSizeCategory: .init(sizeCategory: sizeCategory)
            )
        ])
    }

    public var wrappedValue: Value {
        baseValue.scaled { metrics.scaledValue(for: $0, compatibleWith: traits) }
    }

    /// Creates the scaled metric with an unscaled value using the default scaling.
    public init(baseValue: Value, metrics: UIFontMetrics) {
        self.baseValue = baseValue
        self.metrics = metrics
    }

    /// Creates the scaled metric with an unscaled value using the default scaling.
    public init(wrappedValue: Value) {
        self.init(baseValue: wrappedValue, metrics: UIFontMetrics(forTextStyle: .body))
    }

    /// Creates the scaled metric with an unscaled value and a text style to scale relative to.
    public init(wrappedValue: Value, relativeTo textStyle: UIFont.TextStyle) {
        self.init(baseValue: wrappedValue, metrics: UIFontMetrics(forTextStyle: textStyle))
    }
}

@available(iOS 13, watchOS 6, tvOS 13, *)
private extension UIContentSizeCategory {
    init(sizeCategory: ContentSizeCategory?) {
        switch sizeCategory {
        case .accessibilityExtraExtraExtraLarge: self = .accessibilityExtraExtraExtraLarge
        case .accessibilityExtraExtraLarge: self = .accessibilityExtraExtraLarge
        case .accessibilityExtraLarge: self = .accessibilityExtraLarge
        case .accessibilityLarge: self = .accessibilityLarge
        case .accessibilityMedium: self = .accessibilityMedium
        case .extraExtraExtraLarge: self = .extraExtraExtraLarge
        case .extraExtraLarge: self = .extraExtraLarge
        case .extraLarge: self = .extraLarge
        case .extraSmall: self = .extraSmall
        case .large: self = .large
        case .medium: self = .medium
        case .small: self = .small
        default: self = .unspecified
        }
    }
}

extension CGFloat: Scalable {
    public func scaled(with transform: (CGFloat) -> CGFloat) -> Self {
        transform(self)
    }
}

extension Double: Scalable {
    public func scaled(with transform: (CGFloat) -> CGFloat) -> Self {
        .init(transform(.init(self)))
    }
}

extension CGSize: Scalable {
    public func scaled(with transform: (CGFloat) -> CGFloat) -> Self {
        .init(width: transform(width), height: transform(height))
    }
}

extension CGRect: Scalable {
    public func scaled(with transform: (CGFloat) -> CGFloat) -> Self {
        .init(x: transform(minX), y: transform(minY), width: transform(width), height: transform(height))
    }
}
#endif


