import Foundation

public protocol ValidationRuleAbstract: Error, Hashable {
    var isRegexRule: Bool { get }
    func validate(string: String?) -> Bool
}

@frozen
public enum ValidationRule: Error, Equatable, Hashable, ValidationRuleAbstract {
    case notEmpty
    case minLength(minLen: Int)
    case maxLength(maxLen: Int)
    case matchPattern(pattern: String)
    case conformPattern(pattern: ValidationPattern)
    case cyrillic
    case digit
    case latinic

    public var isRegexRule: Bool {
        switch self {
        case .notEmpty, .maxLength, .minLength:
            return false
        case .conformPattern, .cyrillic, .digit, .matchPattern, .latinic:
            return true
        }
    }

    public static func == (lhs: ValidationRule, rhs: ValidationRule) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }

    public func validate(string: String?) -> Bool {
        guard let string = string, string.count > .zero else {
            if case .notEmpty = self {
                return false
            } else {
                return true
            }
        }

        switch self {
        case .notEmpty:
            return !string.isEmpty
        case let .minLength(minLen):
            return string.count >= minLen
        case let .maxLength(maxLen):
            return string.count <= maxLen
        case .cyrillic:
            return ValidationRule.matchPattern(pattern: ValidationPattern.cyrillic.full).validate(string: string)
        case .digit:
            return ValidationRule.matchPattern(pattern: ValidationPattern.digit.full).validate(string: string)
        case let .conformPattern(pattern):
            return string.isMatching(pattern: pattern.full)

        case let .matchPattern(pattern):
            return string.isMatching(pattern: pattern)
        case .latinic:
            return ValidationRule.matchPattern(pattern: ValidationPattern.latinic.full).validate(string: string)
        }
    }

    public func hash(into hasher: inout Hasher) {
        switch self {
        case .notEmpty:
            return hasher.combine(0)
        case .minLength:
            return hasher.combine(1)
        case .maxLength:
            return hasher.combine(2)
        case .matchPattern:
            return hasher.combine(3)
        case .conformPattern:
            return hasher.combine(4)
        case .cyrillic:
            return hasher.combine(7)
        case .digit:
            return hasher.combine(8)
        case .latinic:
            return hasher.combine(9)
        }
    }
}

