import Foundation

// swiftlint:disable cyclomatic_complexity
public struct ValidationPattern {
    public static let latinic: ValidationPattern = ValidationPattern(subset: "a-zA-Z")
    public static let cyrillic: ValidationPattern = ValidationPattern(subset: "а-яА-ЯёЁ")
    public static let digit: ValidationPattern = ValidationPattern(part: "\\d")
    public static let email: ValidationPattern = ValidationPattern(full: "^(?:[a-zA-Z0-9](?:[a-zA-Z0-9-_]*))+(?:\\.[a-zA-Z0-9-](?:[a-z0-9-_]*)+)*@(?:[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?\\.)+[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
    public static let password: ValidationPattern = ValidationPattern(subset: "a-zA-Z0-9\\-/\\*\\+!")

    public let part: String
    public let full: String

    /// - Parameter part: regex to verify
    public init(part: String) {
        self.part = part
        full = "^\(part)*$"
    }

    /// - Parameter subset: charachter class
    public init(subset: String) {
        part = subset
        full = "^[\(part)]*$"
    }

    public init(part: String, full: String) {
        self.part = part
        self.full = full
    }

    public init(full: String) {
        self.part = full
        self.full = full
    }

    public init(subsetFrom rules: [ValidationRule], rawSubpatterns: [String] = []) {
        guard !rules.isEmpty else {
            full = ".*"
            part = ".*"
            return
        }
        var pattern = "^["
        var count: Int = 0
        for rule in rules {
            if count > .zero {
                pattern.append("|")
            }
            switch rule {
            case .notEmpty, .minLength, .maxLength:
                continue
            case let .matchPattern(subpattern):
                pattern.append(subpattern)
            case .cyrillic:
                pattern.append(ValidationPattern.cyrillic.part)
            case .digit:
                pattern.append(ValidationPattern.digit.part)
            case .latinic:
                pattern.append(ValidationPattern.latinic.part)
            case let .conformPattern(subpattern):
                pattern.append(subpattern.part)
            }
            count += 1
        }
        for subpattern in rawSubpatterns {
            if count > .zero {
                pattern.append("|")
            }
            pattern.append(subpattern)
            count += 1
        }
        pattern.append("]*$")
        full = pattern
        part = pattern
    }

    init(subsetFrom rules: [ValidationRule], withAddition addition: String) {
        guard !rules.isEmpty else {
            full = ".*"
            part = ".*"
            return
        }
        var pattern = "^["
        var count = 0
        for rule in rules {
            if count > .zero {
                pattern.append("|")
            }
            switch rule {
            case .notEmpty, .minLength, .maxLength:
                continue
            case let .matchPattern(subpattern):
                pattern.append(subpattern)
            case .cyrillic:
                pattern.append(ValidationPattern.cyrillic.part)
            case .digit:
                pattern.append(ValidationPattern.digit.part)
            case let .conformPattern(subpattern):
                pattern.append(subpattern.part)
            case .latinic:
                pattern.append(ValidationPattern.latinic.part)
            }
            pattern.append(addition)
            count += 1
        }
        pattern.append("]*$")
        full = pattern
        part = pattern
    }
}
