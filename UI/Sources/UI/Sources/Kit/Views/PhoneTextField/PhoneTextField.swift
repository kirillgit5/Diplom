import SwiftUI
import Core

public struct PhoneTextField: View {
    @Binding private var text: String
    @Binding private var becomeFirstResponder: Bool
    @Binding private var phoneMask: String

    private var onCountryCodeTap: VoidHandler
    private var countryImage: UIImage
    private var phoneCode: String

    private let placeholder: String

    public init(
        text: Binding<String>,
        becomeFirstResponder: Binding<Bool>,
        onCountryCodeTap: @escaping VoidHandler,
        countryImage: UIImage,
        phoneMask: Binding<String>,
        phoneCode: String,
        placeholder: String
    ) {
        self._text = text
        self._becomeFirstResponder = becomeFirstResponder
        self.onCountryCodeTap = onCountryCodeTap
        self.countryImage = countryImage
        self._phoneMask = phoneMask
        self.phoneCode = phoneCode
        self.placeholder = placeholder
    }

    public var body: some View {
        HStack(spacing: 8) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Spacer()
                        .frame(width: 16)
                    Text("Country")
                        .foregroundColor(.Content.primary)
                        .font(.body1())
                }
                HStack {
                    SelectCountryView(
                        phoneCode: phoneCode,
                        countryCodeImage: countryImage,
                        onPress: onCountryCodeTap
                    )
                }
            }
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Spacer()
                        .frame(width: 16)
                    Text("Phone number")
                        .foregroundColor(.Content.primary)
                        .font(.body1())
                }
                HStack {
                    CustomTextField(
                        textBind: $text,
                        becomeFirstResponder: $becomeFirstResponder,
                        foregroundColor: .Content.primary,
                        style: .primary,
                        keyboardType: .numberPad,
                        autocorrectionType: .no,
                        coordinator: PhoneTextFieldCoordinator(text: $text, phoneMask: $phoneMask)
                    )
                    .frame(height: 24)
                    .placeholder(
                        Text(placeholder)
                            .font(Font.body1())
                            .foregroundColor(.Content.tertiary),
                        needShow: text.isEmpty
                    )
                }
                .padding(16)
                .background(Color.Background.primary)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.Controls.primary)
                )
            }
        }
    }
}

class PhoneTextFieldCoordinator: NSObject, CustomTextFieldCoordinator {
    private let text: Binding<String>
    private let phoneMask: Binding<String>

    public init(
        text: Binding<String>,
        phoneMask:  Binding<String>
    ) {
        self.text = text
        self.phoneMask = phoneMask
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    public func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        guard let text = textField.text else { return true }
        let selectedRange = textField.selectedTextRange
        let newString = (text as NSString).replacingCharacters(in: range, with: string)
        let newText = format(phone: newString)
        textField.text = newText
        self.text.wrappedValue = newText
        textField.sendActions(for: .valueChanged)

        guard
            let selectedRange = selectedRange,
            textField.offset(from: textField.beginningOfDocument, to: selectedRange.start) != text.count,
            let offsetPosition = textField.position(from: selectedRange.start, offset: string.isEmpty ? -1 : 1)
        else { return false }

        textField.selectedTextRange = textField.textRange(from: offsetPosition, to: offsetPosition)

        return false
    }

    private func format(phone: String) -> String {
        let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex

        self.phoneMask.wrappedValue.enumerated().forEach { (_, word) in
            guard index < numbers.endIndex else { return }
            if word == "X" {
                result.append(numbers[index])
                index = numbers.index(after: index)
            } else {
                result.append(word)
            }
        }

        return result
    }
}
