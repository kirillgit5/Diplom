import SwiftUI

struct MapViewProxy: UIViewControllerRepresentable {
    typealias UIViewControllerType = MapController

    func makeUIViewController(context: Context) -> MapController {
        let vc = MapController()
        // Do some configurations here if needed.
        return vc
    }

    func updateUIViewController(_ uiViewController: MapController, context: Context) {
        // Updates the state of the specified view controller with new information from SwiftUI.
    }
}
