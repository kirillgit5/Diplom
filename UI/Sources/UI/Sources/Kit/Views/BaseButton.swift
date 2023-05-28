import SwiftUI
import Core

public struct BaseButton: View {
    public enum Kind {
        case primary
        case secondary
    }

    public enum Accessory: Equatable {
        public enum Position: Equatable {
            case leftTitleEdge
            case rightTitleEdge
        }

        case none
        case loader(Position)
        case icon(Image, Position)
    }

    private let isEnabled: Bool
    private let kind: Kind
    private let text: Text
    private let onPress: VoidHandler
    private let accessory: Accessory

    public init(
        isEnabled: Bool,
        kind: Kind,
        text: Text,
        accessory: Accessory,
        onPress: @escaping VoidHandler
    ) {
        self.isEnabled = isEnabled
        self.kind = kind
        self.text = text
        self.onPress = onPress
        self.accessory = accessory
    }

    public var body: some View {
        Button {
            onPress()
        } label: {
            buttonContent
                .foregroundColor(isEnabled ? foregroundActive : foregroundDisabled)
                .padding(16)
                .frame(maxWidth: .infinity, maxHeight: 56)
        }
        .background(isEnabled ? backgroundActive : backgroundDisabled)
        .cornerRadius(16)
        .disabled(!isEnabled)
    }

    @ViewBuilder
    private var buttonContent: some View {
        HStack(spacing: 16) {
            switch accessory {
            case .none:
                text
            case .loader(let position):
                switch position {
                case .leftTitleEdge:
                    ProgressView()
                    text
                    Spacer()
                        .frame(width: 36)
                case .rightTitleEdge:
                    Spacer()
                        .frame(width: 20)
                    text
                    ProgressView()
                }
            case .icon(let image, let position):
                switch position {
                case .leftTitleEdge:
                    image
                    text
                    Spacer()
                        .frame(width: 20)
                case .rightTitleEdge:
                    Spacer()
                        .frame(width: 20)
                    text
                    image
                }
            }
        }
    }
}

private extension BaseButton {
    var backgroundActive: Color {
        switch kind {
        case .primary:
            return .Controls.primary
        case .secondary:
            return .Controls.secondary
        }
    }

    var backgroundDisabled: Color {
        switch kind {
        case .primary:
            return .Controls.primaryDisabled
        case .secondary:
            return .Controls.secondary
        }
    }

    var foregroundActive: Color {
        switch kind {
        case .primary:
            return .Content.primary
        case .secondary:
            return .Content.primary
        }
    }

    var foregroundDisabled: Color {
        switch kind {
        case .primary:
            return .Content.primary
        case .secondary:
            return .Content.primary
        }
    }
}

struct BaseButton_Preview: PreviewProvider {
    static var previews: some View {
        BaseButton(
            isEnabled: true,
            kind: .primary,
            text: Text("Tap on me"),
            accessory: .loader(.rightTitleEdge),
            onPress: {  }
        )
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
