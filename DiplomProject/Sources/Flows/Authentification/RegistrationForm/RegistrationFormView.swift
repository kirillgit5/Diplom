import ComposableArchitecture
import UI
import SwiftUI

struct RegistrationFormView: View {
    let store: StoreOf<RegistrationFormReducer>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            StateWrapper(
                statePublisher: viewStore.publisher.viewState,
                dismissCallback: {  }
            ) {
                ScrollView(.vertical) {
                    VStack(spacing: 16) {
                        Spacer()
                            .frame(height: 12)
                        Text("Enter your personal data for Registration")
                            .font(.title1())
                            .foregroundColor(.Content.primary)
                        Spacer()
                            .frame(height: 8)
                        ForEach(FieldKey.allCases) { key in
                            VStack {
                                HStack {
                                    CustomTextField(
                                        textBind: .init(
                                            get: { viewStore.fieldsModel.fields[key]?.value ?? "" },
                                            set: { value in viewStore.send(.fieldValueDidChange(key, value)) }
                                        ),
                                        becomeFirstResponder: .init(
                                            get: { viewStore.fieldsModel.fields[key]?.isFirstResponder ?? false },
                                            set: { isFirstResponser in viewStore.send(.fieldStateDidChange(key, isFirstResponser)) }
                                        ),
                                        foregroundColor: .Content.primary,
                                        style: .primary,
                                        keyboardType: key.keyboardType,
                                        autocorrectionType: .no
                                    )
                                    .frame(height: 24)
                                    .placeholder(
                                        Text(key.placeholder)
                                            .font(Font.body1())
                                            .foregroundColor(.Content.tertiary),
                                        needShow: viewStore.fieldsModel.fields[key]?.value.isEmpty == true
                                    )
                                }
                                .padding(16)
                                .background(Color.Background.primary)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.Controls.primary)
                                )
                                Spacer(minLength: 4)
                                
                                if let errorText = viewStore.fieldsModel.fields[key]?.errorText {
                                    Text(errorText)
                                        .foregroundColor(.Error.primary)
                                        .font(Font.body4())
                                } else {
                                    Spacer()
                                        .frame(height: 12.6)
                                }
                            }
                        }
                        DropdownSelector(
                            title: "Дата рождения",
                            state: viewStore.binding(
                                get: \.dateSelectorState,
                                send: RegistrationFormReducer.Action.changeSelectorState
                            ),
                            selectedValue: viewStore.selectedDateText,
                            content: {
                                BaseDatePicker(
                                    date: viewStore.binding(
                                        get: \.selectedDate,
                                        send: RegistrationFormReducer.Action.selectDate
                                    ),
                                    dateRange: viewStore.dateRange
                                )
                            }
                        )
                        Spacer()
                            .frame(height: 24)
                        BaseButton(
                            isEnabled: true,
                            kind: .primary,
                            text: Text("Send"),
                            accessory: .none,
                            onPress: { viewStore.send(.registerUser) }
                        )
                    }
                }
                .background(Color.Background.primary)
                .padding(.init(top: 10, leading: 16, bottom: 0, trailing: 16))
            }
        }
    }
}

extension RegistrationFormView {
    enum FieldKey: String, CaseIterable, Identifiable {
        var id: String { rawValue }

        case name
        case surname
        case password
        case passwordRepeat
        case email
    }
}

extension RegistrationFormView.FieldKey {
    var placeholder: String {
        switch self {
        case .name: return "Введите ваше имя"
        case .surname: return "Введите вашу фамилию"
        case .password: return "Введите пароль"
        case .passwordRepeat: return "Повторите пароль"
        case .email: return "Введите ваш email"
        }
    }

    var keyboardType: UIKeyboardType {
        switch self {
        case .name: return .namePhonePad
        case .surname: return .namePhonePad
        case .password: return .default
        case .passwordRepeat: return .default
        case .email: return .emailAddress
        }
    }
}
