import SwiftUI
import Core

struct SelectCountryView: View {
    var phoneCode: String
    var countryCodeImage: UIImage

    let onPress: VoidHandler

    var body: some View {
        Button {
            onPress()
        } label: {
            HStack(spacing: 12) {
                Image(uiImage: countryCodeImage)
                    .clipShape(Circle())
                    .frame(width: 24, height: 24)
                Text(phoneCode)
                    .font(.body1())
                    .foregroundColor(.Content.primary)
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
