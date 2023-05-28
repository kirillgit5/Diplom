import Foundation

@frozen
public enum StringValidationResult {
    case valid
    case invalid(failedRules: [ValidationRule], firstFailedRule: ValidationRule)

    public var isValid: Bool {
        if case .valid = self { return true }
        return false
    }
}

public protocol ValidatorAbstract {
    func validate(_ string: String?) -> StringValidationResult
}

public struct Validator: ValidatorAbstract {
    public let rules: [ValidationRule]

    public init(rules: [ValidationRule] = [.notEmpty],
                isNecessary: Bool = true) {
        if isNecessary {
            self.rules = rules.prependingIfNotContains(.notEmpty)
        } else {
            self.rules = rules
        }
    }

    /// Creates string validator with rules
    /// - Parameters:
    ///   - isNecessary: append .notEmpty rule if _validationCondition rules_ dont contain it
    public init(rule: ValidationRule,
                isNecessary: Bool = true) {
        self.init(rules: [rule],
                  isNecessary: isNecessary)
    }

    /// Creates string validator. Disjunctively merge regex-rules into one and verify it along with non-regex rules
    /// - Parameters:
    ///   - combinedPatternRules: rules for merging
    ///   - isNecessary: append .notEmpty rule if combinedPatternRules dont contain it
    ///   - subsetString: allow other characters from string
    /// - Important: Dont forget escape special characters!
    public init(combinedPatternRules: [ValidationRule],
                isNecessary: Bool = true,
                withAllowedCharacters subsetString: String) {
        let regexRules: [ValidationRule] = combinedPatternRules.filter({ $0.isRegexRule })
        if regexRules.isEmpty {
            self.init(rules: combinedPatternRules, isNecessary: isNecessary)
        }

        let nonRegexRules: [ValidationRule] = combinedPatternRules.filter({ !$0.isRegexRule })
        let pattern: ValidationPattern = ValidationPattern(
            subsetFrom: regexRules,
            rawSubpatterns: [subsetString]
        )
        let rules: [ValidationRule] = nonRegexRules.appending(ValidationRule.conformPattern(pattern: pattern))
        self.init(rules: rules,
                  isNecessary: isNecessary)
    }

    public func validate(_ string: String?) -> StringValidationResult {
        for rule in rules {
            if !rule.validate(string: string) {
                return StringValidationResult.invalid(failedRules: rules,
                                                      firstFailedRule: rule)
            }
        }

        return .valid
    }
}
