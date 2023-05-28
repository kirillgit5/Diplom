import ComposableArchitecture
import UI
import SwiftUI

struct AllChatsView: View {
    let store: StoreOf<AllChatsReducer>

    var body: some View {
        VStack {
            VStack {
                HStack(alignment: .top) {
                    Image(uiImage: Asset.avatar1.image)
                        .resizable()
                        .frame(width: 70, height: 70)
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(32)
                    Spacer()
                        .frame(width: 12)
                    VStack(alignment: .leading) {
                        Text("Иванов Иван")
                            .font(Font.body1())
                            .foregroundColor(.Content.primary)
                            .multilineTextAlignment(.leading)
                        Spacer()
                            .frame(height: 8)
                        Text("Привет")
                            .font(Font.caption1())
                            .foregroundColor(.Content.tertiary)
                            .multilineTextAlignment(.leading)
                    }
                    Spacer()
                    VStack {
                        Text("9:28")
                            .font(Font.body4())
                            .foregroundColor(.Content.tertiary)
                            .multilineTextAlignment(.trailing)
                    }
                }
                Spacer()
                    .frame(height: 8)
                VStack {
                    Divider()
                }
                .padding(32)
                .frame(height: 1)
            }
            VStack {
                HStack(alignment: .top) {
                    Image(uiImage: Asset.avatar2.image)
                        .resizable()
                        .frame(width: 70, height: 70)
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(32)
                    Spacer()
                        .frame(width: 12)
                    VStack(alignment: .leading) {
                        Text("Петрова Анна")
                            .font(Font.body1())
                            .foregroundColor(.Content.primary)
                            .multilineTextAlignment(.leading)
                        Spacer()
                            .frame(height: 8)
                        Text("Привет")
                            .font(Font.caption1())
                            .foregroundColor(.Content.tertiary)
                            .multilineTextAlignment(.leading)
                    }
                    Spacer()
                    VStack {
                        Text("7:32")
                            .font(Font.body4())
                            .foregroundColor(.Content.tertiary)
                            .multilineTextAlignment(.trailing)
                    }
                }
                Spacer()
                    .frame(height: 8)
            }
            Spacer()
        }
        .padding(16)
    }
}
