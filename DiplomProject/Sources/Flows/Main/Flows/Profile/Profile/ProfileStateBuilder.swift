import Services
import Core

struct ProfileStateBuilder {
    private let sessionStorage: SessionStorage

    init(sessionStorage: SessionStorage) {
        self.sessionStorage = sessionStorage
    }

    func buildInitialState() -> ProfileReducer.State {
        .init(
            name: "\(sessionStorage.firstName ?? "") \(sessionStorage.surname ?? "")",
            phoneNumber: sessionStorage.phoneNumber ?? "",
            isDriver: sessionStorage.userType == .driver
        )
    }
}
