import SwiftUI

public struct FloatPopupView: View {
    private let text: String
    private let image: UIImage

    public init(
        text: String,
        image: UIImage
    ) {
        self.text = text
        self.image = image
    }

    public var body: some View {
        HStack(spacing: 16) {
            Image(uiImage: image)
                .frame(width: 24, height: 24)
            Text(text)
                .font(Font.headline())
                .foregroundColor(Color.Content.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .frame(minHeight: 70)
        .background(Color.Background.primary.cornerRadius(16))
        .shadowDrop1()
        .padding(.horizontal, 16)
    }
}
