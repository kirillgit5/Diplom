import SwiftUI
import ComposableArchitecture

struct MapView: View {
    let store: StoreOf<MapReducer>

    var body: some View {
        MapViewProxy()
    }
}
