import ComposableArchitecture
import UI
import SwiftUI

struct ProfileView: View {
    let store: StoreOf<ProfileReducer>
    @State private var settingsDetent = PresentationDetent.medium

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                HStack {
                    AsyncImage(url: URL(string: "https://avatars.mds.yandex.net/i?id=0bbfba76fa1a5c41fdd70575a344a72f-5226953-images-thumbs&n=13"))
                        .frame(width: 80, height: 80)
                        .aspectRatio(contentMode: .fill)
                        .cornerRadius(40)
                    Spacer()
                        .frame(width: 12)
                    VStack(alignment: .leading) {
                        Text(viewStore.name)
                            .font(Font.body1())
                            .foregroundColor(.Content.primary)
                            .multilineTextAlignment(.leading)
                        Spacer()
                            .frame(height: 8)
                        Text(viewStore.phoneNumber)
                            .font(Font.body1())
                            .foregroundColor(.Content.tertiary)
                            .multilineTextAlignment(.leading)
                    }
                    Spacer()
                }
                .padding()
                    .background(Color.Background.primary)
                    .shadowDrop2()
                Spacer()
                    .frame(height: 16)
                    .background(Color.Content.tertiary)

                HStack {
                    Text("Текущий режим:  \(viewStore.isDriver ? "Водитель" : "Попутчик")")
                        .font(.body1())
                        .foregroundColor(.Content.primary)
                    Spacer()
                    Image(uiImage: Asset.passenger.image)
                        .resizable()
                        .renderingMode(.template)
                        .colorMultiply(viewStore.isDriver ? .Content.tertiary : .Content.accentPrimary)
                        .foregroundColor(viewStore.isDriver ? .Content.tertiary : .Content.accentPrimary)
                        .frame(width: 24, height: 24)
                    Spacer()
                        .frame(width: 8)
                    Toggle(
                        "",
                        isOn: viewStore.binding(
                            get: \.isDriver,
                            send: ProfileReducer.Action.changeDriverStatus
                        )
                    )
                    .toggleStyle(SwitchToggleStyle(tint: .Content.accentPrimary))
                    .labelsHidden()
                    Spacer()
                        .frame(width: 8)
                    Image(uiImage: Asset.car.image)
                        .resizable()
                        .renderingMode(.template)
                        .colorMultiply(viewStore.isDriver ? .Content.accentPrimary : .Content.tertiary)
                        .foregroundColor(viewStore.isDriver ? .Content.accentPrimary : .Content.tertiary)
                        .frame(width: 24, height: 24)
                }
                .padding(16)
                .background(Color.Background.primary)
                .cornerRadius(6)
                .shadowDrop2()
                Spacer()
            }
            .padding(16)
            .background(Color.Background.primary)
            .sheet(
                isPresented: viewStore.binding(
                    get: \.showAdditionalRegistration,
                    send: ProfileReducer.Action.additionalRegistrationClosed
                ),
                content: {
                    VStack {
                        VStack {
                            Spacer()
                                .frame(height: 16)
                            Text("Заполните дополнительную информацию")
                                .font(Font.headline())
                                .foregroundColor(.Content.primary)
                            Spacer()
                                .frame(height: 32)
                            Text("Для поиска попутчиков, заполните информацию о вашем транспортном средстве")
                                .font(Font.body1())
                                .foregroundColor(.Content.primary)
                                .fixedSize(horizontal: false, vertical: true)
                            Spacer()
                                .frame(height: 20)
                        }
                        HStack {
                            CustomTextField(
                                textBind: viewStore.binding(
                                    get: \.carNumber,
                                    send: ProfileReducer.Action.carNumberChanged
                                ),
                                becomeFirstResponder: viewStore.binding(
                                    get: \.carNumberIsFirstResponser,
                                    send: ProfileReducer.Action.carNumberBecomeFirstResponder
                                ),
                                foregroundColor: .Content.primary,
                                style: .primary
                            )
                            .placeholder(
                                Text("Введите номер машины")
                                    .font(Font.body1())
                                    .foregroundColor(.Content.tertiary),
                                needShow: viewStore.carNumber.isEmpty
                            )
                        }
                        .padding(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.Controls.primary)
                        )
                        Spacer()
                            .frame(height: 16)
                        HStack {
                            CustomTextField(
                                textBind: viewStore.binding(
                                    get: \.carInfo,
                                    send: ProfileReducer.Action.carInfoChanged
                                ),
                                becomeFirstResponder: viewStore.binding(
                                    get: \.carInfoIsFirstResponder,
                                    send: ProfileReducer.Action.carNumberBecomeFirstResponder
                                ),
                                foregroundColor: .Content.primary,
                                style: .primary
                            )
                            .placeholder(
                                Text("Введите марку машины")
                                    .font(Font.body1())
                                    .foregroundColor(.Content.tertiary),
                                needShow: viewStore.carInfo.isEmpty
                            )
                        }
                        .padding(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.Controls.primary)
                        )
                        Spacer()
                            .frame(height: 16)
                        HStack {
                            CustomTextField(
                                textBind: viewStore.binding(
                                    get: \.carColor,
                                    send: ProfileReducer.Action.carColorChanged
                                ),
                                becomeFirstResponder: viewStore.binding(
                                    get: \.carColorIsFirstResponser,
                                    send: ProfileReducer.Action.carColorBecomeFirstResponder
                                ),
                                foregroundColor: .Content.primary,
                                style: .primary
                            )
                            .placeholder(
                                Text("Введите цвет")
                                    .font(Font.body1())
                                    .foregroundColor(.Content.tertiary),
                                needShow: viewStore.carColor.isEmpty
                            )
                        }
                        .padding(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.Controls.primary)
                        )
                        Spacer()
                            .frame(height: 56)
                        BaseButton(
                            isEnabled: true,
                            kind: .primary,
                            text: Text("Отравить"),
                            accessory: .none,
                            onPress: { viewStore.send(.sendAdditionalInfo) }
                        )
                    }
                    .presentationDetents(
                                        [.medium, .large],
                                        selection: $settingsDetent
                                     )
                    .padding(16)
                    .background(Color.Background.primary)
                }
            )
        }
    }
}
