import SwiftUI

struct LoadableView: View {
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.Controls.primary))
                    .scaleEffect(2)
                    .frame(width: 84, height: 84)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .foregroundColor(Color.Background.tertiaryBlur)
                            .frame(width: 140, height: 142)
                            
                    )
                Spacer()
            }
            Spacer()
        }
        .background(Color.Background.tertiaryBlur)
    }
}
