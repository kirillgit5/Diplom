import Services
import UI

struct SetBiometryStateBuilder {
    private let quickAccess: QuickAccess

    init(quickAccess: QuickAccess) {
        self.quickAccess = quickAccess
    }

    func buildInitialState() -> SetBiometryReducer.State {
        .init(
            title: quickAccess.biometry.name,
            description: "Setup Biometry",
            image: quickAccess.biometry.image
        )
    }
}
