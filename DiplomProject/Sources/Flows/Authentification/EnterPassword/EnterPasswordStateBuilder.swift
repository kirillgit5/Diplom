import Services
import UI

struct EnterPasswordStateBuilder {
    private let quickAccess: QuickAccess

    init(quickAccess: QuickAccess) {
        self.quickAccess = quickAccess
    }

    func buildInitialState() -> EnterPasswordReducer.State {
        .init(biometryType: .faceID)
    }
}
