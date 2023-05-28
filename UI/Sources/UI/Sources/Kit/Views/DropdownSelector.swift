import SwiftUI

public struct DropdownSelector<Content: View>: View {
    private let title: String
    @Binding private var state: DropdownSelectorState
    private let content: Content
    private let selectedValue: String

    public init(
        title: String,
        state: Binding<DropdownSelectorState>,
        selectedValue: String,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self._state = state
        self.selectedValue = selectedValue
        self.content = content()
    }

    public var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(title)
                    .font(.body1())
                    .foregroundColor(.Content.primary)
                Spacer()
                Text(selectedValue)
                    .font(.body1())
                    .foregroundColor(.Content.accentPrimary)
                Image(uiImage: Asset.chevronRight.image)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.Content.accentPrimary)
            }
            .padding()
            .background(Color.Background.primary)
            .onTapGesture {
                withAnimation(.easeIn(duration: 0.2)) {
                    state = state.toggle()
                }
            }

            content
                .frame(height: state == .expanded ? nil : 0, alignment: .top)
                .clipped()
        }
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.Background.accentPrimary, lineWidth: 1)
        )
    }
}

public enum DropdownSelectorState: Equatable {
    case collapse
    case expanded

    func toggle() -> Self {
        self == .collapse ? .expanded : .collapse
    }
}
