import CoreLocation

public final class LocationService: NSObject {
    public static let shared = LocationService()

    private let locationManager = CLLocationManager()

    public var locationUpdated: ((CLLocation) -> Void)?

    private override init() {
        super.init()
        startTrackLocation()
    }

    public func startTrackLocation() {
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }

    private func requestPermission() {
        guard CLLocationManager.locationServicesEnabled() else { return }

        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse:
            break
        case .notDetermined, .restricted, .denied:
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            assertionFailure()
        }
    }
}

extension LocationService: CLLocationManagerDelegate {
    public func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        guard let location = locations.last else { return }

        locationUpdated?(location)
    }

    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedAlways || status == .authorizedWhenInUse else {
            requestPermission()
            return
        }
        locationManager.startUpdatingLocation()
    }
}
