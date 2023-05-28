import Foundation
import UI
import Core

struct RegistrationFormFieldsModel: Equatable {
    typealias Key = RegistrationFormView.FieldKey

    private(set) var fields: [Key: TextFieldModel]

    init() {
        var fields: [Key: TextFieldModel] = [:]


        Key.allCases.forEach { fields[$0] = TextFieldModel(text: "", isFirstResponder: false) }
        self.fields = fields
        setupValidation()
    }

    mutating func validate() -> Bool {
        !Key.allCases.map { key in
            guard let field = fields[key] else { return true }
            let validator = Validator(rules: Array(field.validationRules.keys))

            switch validator.validate(field.value) {
            case .valid: return true
            case .invalid(_, let firstFailedRule):
                fields[key]?.errorText = field.validationRules[firstFailedRule]
                return false
            }
        }
        .contains(false)
    }

    private mutating func setupValidation() {
        Key.allCases.forEach { key in
            let validationRules: [ValidationRule: String]

            switch key {
            case .email:
                validationRules = [.conformPattern(pattern: ValidationPattern.email): "Invalid Email"]
            case .surname:
                validationRules = [
                    .cyrillic: "Only Cyrillic",
                    .maxLength(maxLen: 20): "Максимальная длина 20",
                    .minLength(minLen: 6): "Минимальная длина 6"
                ]
            case .name:
                validationRules = [
                    .cyrillic: "Only Cyrillic",
                    .maxLength(maxLen: 20): "Максимальная длина 20",
                    .minLength(minLen: 6): "Минимальная длина 6"
                ]
            case .password:
                validationRules = [
                    .minLength(minLen: 6): "Минимальная длина 6",
                    .maxLength(maxLen: 12): "Максимальная длина 20",
                    .conformPattern(pattern: ValidationPattern(subsetFrom: [
                        .digit,
                        .latinic
                    ])): "Не подходит"
                ]
            case .passwordRepeat:
                validationRules = [:]
            }

            fields[key]?.validationRules = validationRules
        }
    }

    public func value(by key: Key) -> String {
        fields[key]?.value ?? ""
    }

    public mutating func set(value: String, for key: Key) {
        fields[key]?.value = value
    }

    public mutating func set(isFirstResponser: Bool, for key: Key) {
        fields[key]?.isFirstResponder = isFirstResponser
    }
}
