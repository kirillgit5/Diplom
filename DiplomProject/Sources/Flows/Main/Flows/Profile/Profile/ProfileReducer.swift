import ComposableArchitecture
import Core
import UI
import Services

struct ProfileReducer: ReducerProtocol {
    struct State: Equatable {
        var name: String
        var phoneNumber: String
        var isDriver: Bool
        var viewState: ViewState = .pending
        var carNumber: String = ""
        var carColor: String = ""
        var carInfo: String = ""
        var carInfoIsFirstResponder = false
        var carNumberIsFirstResponser = false
        var carColorIsFirstResponser = false
        var showAdditionalRegistration: Bool = false
    }

    enum Action: Equatable {
        case changeDriverStatus(Bool)
        case checkDriverExist
        case checkDriverExistResponse(TaskResult<Int>)
        case sendAdditionalInfo
        case sendAdditionalInfoResponse(TaskResult<Int>)
        case additionalRegistrationClosed(Bool)
        case carColorChanged(String)
        case carNumberChanged(String)
        case carInfoChanged(String)
        case carInfoBecomeFirstResponder(Bool)
        case carNumberBecomeFirstResponder(Bool)
        case carColorBecomeFirstResponder(Bool)
    }

    private let sessionStorage: SessionStorage
    private let homeClient: HomeClient

    init(
        sessionStorage: SessionStorage,
        homeClient: HomeClient
    ) {
        self.sessionStorage = sessionStorage
        self.homeClient = homeClient
    }

    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .changeDriverStatus(let isDriver):
//            if !isDriver {
//                if sessionStorage.wasDriver {
//                    state.isDriver = true
//                    return .none
//                } else {
//                    return .task { .checkDriverExist }
//                }
//            } else {
//                state.isDriver = false
//                return .none
//            }
//            state.isDriver.toggle()
            state.showAdditionalRegistration = true
            return .none
        case .checkDriverExist:

            let params = CheckDriverExistParams(phone: state.phoneNumber)

            state.viewState = .loading(.normal)

            return .task {
                await .checkDriverExistResponse(TaskResult { try await self.homeClient.checkDriverExist(with: params) })
            }
        case .checkDriverExistResponse(.failure):
            state.viewState = .error(.snack(.init(message: "Ошибка")))
            return .none
        case .checkDriverExistResponse(.success(let code)):
            switch code {
            case 200:
                state.isDriver = true
                sessionStorage.wasDriver = true
            case 403:
                state.showAdditionalRegistration = true
            default:
                state.viewState = .error(.snack(.init(message: "Ошибка")))
            }

            return .none
        case .sendAdditionalInfo:

            let params = SendAdditionalInfoParams(
                phone: state.phoneNumber,
                carInfo: "\(state.carInfo); Цвет: \(state.carColor)",
                carNumber: state.carNumber
            )

            state.showAdditionalRegistration = false
            state.viewState = .loading(.normal)

            return .task {
                await .sendAdditionalInfoResponse(TaskResult { try await self.homeClient.sendAdditionalInfo(with: params) })
            }
        case .sendAdditionalInfoResponse(.failure):
            state.viewState = .error(.snack(.init(message: "Ошибка")))
            return .none
        case .sendAdditionalInfoResponse(.success(let code)):
            switch code {
            case 200, 201:
                state.isDriver = true
                state.viewState = .pending
            default:
                state.viewState = .error(.snack(.init(message: "Ошибка")))
            }

            return .none

        case .additionalRegistrationClosed(let additionalRegistrationClosed):
            state.showAdditionalRegistration = additionalRegistrationClosed
            return .none
        case .carColorChanged(let carColor):
            state.carColor = carColor
            return .none
        case .carInfoChanged(let carInfo):
            state.carInfo = carInfo
            return .none
        case .carNumberChanged(let carNumber):
            state.carNumber = carNumber
            return .none
        case .carInfoBecomeFirstResponder(let bool):
            state.carInfoIsFirstResponder = bool
            return .none
        case .carNumberBecomeFirstResponder(let bool):
            state.carNumberIsFirstResponser = bool
            return .none
        case .carColorBecomeFirstResponder(let bool):
            state.carColorIsFirstResponser = bool
            return .none
        }
    }
}
