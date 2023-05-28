import SwiftUI
import Combine
import ComposableArchitecture
import Core

public struct StateWrapper<Content: View>: View {

    @State private var snackConfig: SnackErrorConfig?
    @State private var showPopUp: Bool = false
    @State private var isLoading: Bool = false

    private let statePublisher: StorePublisher<ViewState>
    private let content: Content
    private let dismissCallback: VoidHandler

    public init(
        statePublisher: StorePublisher<ViewState>,
        dismissCallback: @escaping VoidHandler,
        @ViewBuilder content: () -> Content
    ) {
        self.statePublisher = statePublisher
        self.dismissCallback = dismissCallback
        self.content = content()
    }

    public var body: some View {
        ZStack {
            content
                .floatPopup(
                    showPopUp: $showPopUp,
                    text: snackConfig?.message ?? "",
                    dismissCallback: dismissCallback
                )

            if isLoading {
                LoadableView()
            }
        }
        .onReceive(
            statePublisher,
            perform: { state in
                showPopUp = state.isSnackError
                snackConfig = state.snackConfig
                isLoading = state.isNormalLoading
            }
        )
    }
}
