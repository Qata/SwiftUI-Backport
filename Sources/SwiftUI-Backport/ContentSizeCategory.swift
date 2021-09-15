import SwiftUI

@available(iOS 13.0, tvOS 14.0, watchOS 7.0, *)
@available(iOS, deprecated: 14.0)
@available(tvOS, deprecated: 14.0)
@available(watchOS, deprecated: 7.0)
public extension ContentSizeCategory {
    /// Returns a Boolean value indicating whether the value of the first argument is less than that of the second argument.
    @_disfavoredOverload
    static func < (lhs: ContentSizeCategory, rhs: ContentSizeCategory) -> Bool {
        guard let lhsIndex = Self.allCases.firstIndex(of: lhs),
              let rhsIndex = Self.allCases.firstIndex(of: rhs)
        else {
            return false
        }
        if lhsIndex.distance(to: rhsIndex) > 0 {
            return true
        } else {
            return false
        }
    }

    /// Returns a Boolean value indicating whether the value of the first argument is less than or equal to that of the second argument.
    @_disfavoredOverload
    static func <= (lhs: ContentSizeCategory, rhs: ContentSizeCategory) -> Bool {
        lhs == rhs || lhs < rhs
    }

    /// Returns a Boolean value indicating whether the value of the first argument is greater than that of the second argument.
    @_disfavoredOverload
    static func > (lhs: ContentSizeCategory, rhs: ContentSizeCategory) -> Bool {
        !(lhs <= rhs)
    }

    /// Returns a Boolean value indicating whether the value of the first argument is greater than or equal to that of the second argument.
    @_disfavoredOverload
    static func >= (lhs: ContentSizeCategory, rhs: ContentSizeCategory) -> Bool {
        lhs == rhs || lhs > rhs
    }
    
    @_disfavoredOverload
    var isAccessibilityCategory: Bool {
        switch self {
        case .extraSmall,
             .small,
             .medium,
             .large,
             .extraLarge,
             .extraExtraLarge,
             .extraExtraExtraLarge:
            return false
        case .accessibilityMedium,
             .accessibilityLarge,
             .accessibilityExtraLarge,
             .accessibilityExtraExtraLarge,
             .accessibilityExtraExtraExtraLarge:
            return true
        @unknown default:
            // If a new category is added, it's probably not a non-accessible one.
            return true
        }
    }
}
