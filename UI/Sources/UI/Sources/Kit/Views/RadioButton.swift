import SwiftUI

public struct RadioButton: View {
    @Binding var isOn: Bool

    public init(isOn: Binding<Bool>) {
        self._isOn = isOn
    }

    public var body: some View {
        Toggle("", isOn: $isOn)
            .toggleStyle(RadioButtonStyle())
    }
}

struct RadioButtonStyle: ToggleStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        Circle()
            .fill(Color.Controls.primaryEdit)
            .overlay(
                Circle().stroke(
                    configuration.isOn ? Color.Controls.primary : Color.Controls.disabled,
                    lineWidth: configuration.isOn ? 6 : 2
                )
            )
            .frame(width: 22, height: 22)
            .onTapGesture { configuration.isOn.toggle() }
    }
}

struct RadioButton_Preview: PreviewProvider {
    @State static var isOn: Bool = true
    static var previews: some View {
        RadioButton(isOn: $isOn)
            .previewLayout(.sizeThatFits)
    }
}
