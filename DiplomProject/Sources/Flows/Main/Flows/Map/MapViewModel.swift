import Services
import CoreLocation
import GoogleMapsUtils
import GoogleMaps

struct GeocodeUiModel {
    let formattedAddress: String?
    let lat: Double
    let lng: Double
}

enum MarkerState {
    case start
    case end
    case go

    var text: String {
        switch self {
        case .start: return "Выберите начальную точку"
        case .end: return "Выберите конечную точку"
        case .go: return "Поехали!"
        }
    }
}

final class MapViewModel {
    private let locationService: LocationService = .shared
    private let homeClient: HomeClient = HomeClient()
    private let sessionStorage: SessionStorage = .shared

    var markerState: MarkerState = .start

    var markerA: GMSMarker?
    var markerB: GMSMarker?

    var locationsUpdated: ((CLLocation) -> Void)?

    var showDirection: (([GMSPolyline]) -> Void)?

    var locationFinded: ((GeocodeUiModel) -> Void)?

    var onDriverSelect: ([CompanionFindResponse] -> Void)?

    init() {
        setupBindings()
    }

    func askPermissions() {
        locationService.startTrackLocation()
    }

    func geocodeLocation(address: String) async {
        let location = try? await homeClient.getGeocodeLocation(address: address)

        guard let location = location else { return }

        let model = GeocodeUiModel(
            formattedAddress: location.results?.first?.formatted_address,
            lat: location.results?.first?.geometry.location.lat ?? 0,
            lng: location.results?.first?.geometry.location.lng ?? 0
        )

        locationFinded?(model)
    }

    func startTravel() async {
        guard let markerA = markerA,
              let markerB = markerB
        else { return }

        let direction = try? await homeClient.direction(
            destination: "\(markerB.position.latitude),\(markerB.position.longitude)",
            origin: "\(markerA.position.latitude),\(markerA.position.longitude)"
        )

        guard let direction = direction else { return }

        DispatchQueue.main.async {
            let polyline = direction.routes?.first?.legs.first?.steps.map { step in
                GMSPolyline(path: .init(fromEncodedPath: step.polyline.points))
            }

            self.showDirection?(polyline!)
        }

        if sessionStorage.userType == .companion {
            let params = CompanionFindParams(
                route: CompanionFindParams.Route(
                    startPoint: .init(lat: markerA.position.latitude, lng: markerA.position.longitude),
                    endPoint: .init(lat: markerB.position.latitude, lng: markerB.position.longitude)
                ),
                time: 15,
                percent: 80
            )

            let result = try? await homeClient.postCompanionFind(params: params)
        } else {
            let params = CreateDriverParams(
                id: "1",
                calories: .init(
                    startPoint: .init(lat: markerA.position.latitude, lng: markerA.position.longitude),
                    endPoint: .init(lat: markerB.position.latitude, lng: markerB.position.longitude)
                ),
                status: "InProgress"
            )

            let result = try? await homeClient.postCreateDriver(params: params)
        }
    }

    private func setupBindings() {
        locationService.locationUpdated = { [weak self] location in
            self?.locationsUpdated?(location)
        }
    }
}
