import SwiftUI
import PopupView

public extension View {
    func floatPopup(
        showPopUp: Binding<Bool>,
        text: String,
        image: UIImage = Asset.sad.image,
        dismissCallback: @escaping () -> ()
    ) -> some View {
        self.popup(
            isPresented: showPopUp,
            type: .floater(),
            position: .top,
            animation: .spring(),
            autohideIn: 3,
            dismissCallback: dismissCallback
        ) {
            FloatPopupView(
                text: text,
                image: image
            )
        }
    }
}
