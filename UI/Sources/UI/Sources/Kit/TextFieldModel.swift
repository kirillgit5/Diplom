import SwiftUI
import Core

public struct TextFieldModel: Equatable {
    public static func == (lhs: TextFieldModel, rhs: TextFieldModel) -> Bool {
        lhs.value == rhs.value && lhs.errorText == rhs.errorText
    }

    public var value: String {
        didSet {
            errorText = nil
        }
    }
    public var isFirstResponder: Bool
    public var errorText: String?
    public var validationRules: [ValidationRule: String]

    public init(
        text: String,
        isFirstResponder: Bool,
        validationRules: [ValidationRule: String] = [:]
    ) {
        value = text
        self.isFirstResponder = isFirstResponder
        self.validationRules = validationRules
    }
}
