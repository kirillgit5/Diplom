import SwiftUI



public struct CustomTextField: UIViewRepresentable {
    public enum Style {
        case primary
    }

    @Binding var text: String
    @Binding var becomeFirstResponder: Bool

    private var foregroundColor: CGColor?
    private let style: Style
    private let keyboardType: UIKeyboardType
    private let autocorrectionType: UITextAutocorrectionType
    private let autocapitalizationType: UITextAutocapitalizationType
    private let spellCheckingType: UITextSpellCheckingType
    private let isSecure: Bool
    private let _coordinator: Coordinator

    private var textColor: Color {
        switch style {
        case .primary: return .Content.primary
        }
    }

    public init(
        textBind: Binding<String>,
        becomeFirstResponder: Binding<Bool>,
        foregroundColor: Color,
        style: Style,
        keyboardType: UIKeyboardType = .default,
        autocorrectionType: UITextAutocorrectionType = .default,
        autocapitalizationType: UITextAutocapitalizationType = .sentences,
        spellCheckingType: UITextSpellCheckingType = .default,
        coordinator: CustomTextFieldCoordinator? = nil,
        isSecure: Bool = false
    ) {
        self._text = textBind
        self._becomeFirstResponder = becomeFirstResponder
        self.foregroundColor = foregroundColor.cgColor
        self.style = style
        self.keyboardType = keyboardType
        self.autocorrectionType = autocorrectionType
        self.autocapitalizationType = autocapitalizationType
        self.spellCheckingType = spellCheckingType
        self.isSecure = isSecure
        self._coordinator = coordinator ?? DefaultCoordinator(text: textBind, didBecomeFirstResponder: becomeFirstResponder)
    }

    public func makeUIView(context: Context) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        textField.keyboardType = keyboardType
        textField.autocorrectionType = autocorrectionType
        textField.autocapitalizationType = autocapitalizationType
        textField.spellCheckingType = spellCheckingType
        textField.returnKeyType = .done
        textField.delegate = context.coordinator
        textField.isSecureTextEntry = isSecure
        return textField
    }

    public func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
        uiView.textColor = UIColor(textColor)

        if becomeFirstResponder {
            DispatchQueue.main.async {
                uiView.becomeFirstResponder()
            }
        } else {
            DispatchQueue.main.async {
                uiView.resignFirstResponder()
            }
        }
    }

    public func makeCoordinator() -> CustomTextFieldCoordinator {
        return _coordinator
    }
}

public protocol CustomTextFieldCoordinator: UITextFieldDelegate {}

public final class DefaultCoordinator: NSObject, CustomTextFieldCoordinator {
    @Binding var text: String
    @Binding var didBecomeFirstResponder: Bool

    init(
        text: Binding<String>,
        didBecomeFirstResponder: Binding<Bool>
    ) {
        _text = text
        _didBecomeFirstResponder = didBecomeFirstResponder
    }

    public func textFieldDidBeginEditing(_ textField: UITextField) {
        didBecomeFirstResponder = true
    }

    public func textFieldDidChangeSelection(_ textField: UITextField) {
        text = textField.text ?? ""
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
