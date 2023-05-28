import GoogleMaps
import GoogleMapsUtils
import SnapKit
import UI

class PlacePicker: UIView {
    init() {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        let palka = UIView()
        palka.backgroundColor = UIColor(hex: 0x34D5DC)

        let circle = UIView()
        circle.backgroundColor = UIColor(hex: 0x34D5DC)
        circle.layer.cornerRadius = 20

        addSubview(circle)
        addSubview(palka)

        circle.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.size.equalTo(40)
        }

        palka.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(circle.snp.bottom)
            $0.height.equalTo(30)
            $0.width.equalTo(2)
        }

        let intCircle = UIView()
        intCircle.backgroundColor = .white

        circle.addSubview(intCircle)

        intCircle.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(16)
        }

        intCircle.layer.cornerRadius = 8
    }
}

final class MapController: UIViewController {
    private let viewModel = MapViewModel()

    let textField = UITextField()

    private let titleLabel = UILabel()

    private let placePicker = PlacePicker()

    private let selectLocation = UIButton()

    private let clearButton = UIButton()

    private enum Constants {
        // Set the point in the middle of Bulgaria capital - Sofia.
        static let baseLocation = CLLocation(
            latitude: CLLocationDegrees(54.709428),
            longitude: CLLocationDegrees(20.47)
        )
        static let zoom: Float = 104334343
    }

    var mapView = GMSMapView.map(
        withFrame: .zero,
        camera: .init(
            latitude: Constants.baseLocation.coordinate.latitude,
            longitude: Constants.baseLocation.coordinate.longitude,
            zoom: 10
        )
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBindings()
        setupMap()
        setupTextField()
        setupLabel()
        viewModel.askPermissions()
        setupPicker()
        setupSelectLocation()
        titleLabel.text = viewModel.markerState.text
    }

    private func setupBindings() {
        viewModel.onDriverSelect = { [weak self] drivers in
            let vc = SelectDriverController(drivers: drivers)

            self?.present(vc, animated: true)
        }

        viewModel.locationsUpdated = { [weak self] location in
//            self?.moveCameraToLocation(location: location)
        }

        viewModel.showDirection = { polylines in
            polylines.forEach {
                $0.map = self.mapView
            }

            self.mapView.animate(toZoom: 5)
        }

        viewModel.locationFinded = { location in
            DispatchQueue.main.async {
                switch self.viewModel.markerState {
                case .start:
                    let marker = GMSMarker()
                    marker.position = .init(latitude: location.lat, longitude: location.lng)
                    marker.map = self.mapView
                    marker.title = "От"
                    self.viewModel.markerA = marker
                    self.viewModel.markerState = .end
                    self.titleLabel.text = self.viewModel.markerState.text
                case .end, .go:
                    let marker = GMSMarker()
                    marker.position = .init(latitude: location.lat, longitude: location.lng)
                    marker.map = self.mapView
                    marker.title = "До"
                    self.viewModel.markerB?.map = nil
                    self.viewModel.markerB = marker
                    self.viewModel.markerState = .go
                    self.titleLabel.text = ""
                    self.selectLocation.setTitle(self.viewModel.markerState.text, for: .normal)
                }
                
                let camera = GMSCameraPosition.camera(
                    withLatitude: location.lat,
                    longitude: location.lng,
                    zoom: 10
                )
                
                self.mapView.animate(to: camera)
            }
        }
    }

    private func setupMap() {
        view.addSubview(mapView)

        mapView.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalToSuperview()
        }

        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.delegate = self
        mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 10)

        moveCameraToLocation()
    }

    private func setupTextField() {
        view.insertSubview(textField, aboveSubview: mapView)

        textField.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview().inset(16)
        }

        textField.placeholder = "Поиск места"
        textField.borderStyle = .roundedRect
        textField.layer.borderColor = UIColor(hex: 0x34D5DC).cgColor
        textField.layer.borderWidth = 2
        textField.layer.cornerRadius = 6
        textField.clipsToBounds = true
        textField.delegate = self
    }

    private func setupLabel() {
        view.insertSubview(titleLabel, aboveSubview: mapView)

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(textField.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
    }

    private func setupPicker() {
        view.insertSubview(placePicker, aboveSubview: mapView)

        placePicker.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(-34)
            $0.centerX.equalToSuperview().offset(-6)
        }
    }

    private func setupSelectLocation() {
        view.insertSubview(selectLocation, aboveSubview: mapView)
        selectLocation.setTitle("Выбрать точку", for: .normal)
        selectLocation.backgroundColor = UIColor(hex: 0x34D5DC)
        selectLocation.layer.cornerRadius = 16

        selectLocation.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(80)
            $0.bottom.equalToSuperview().inset(32)
            $0.height.equalTo(56)
        }

        selectLocation.addTarget(self, action: #selector(selectLcoation), for: .touchUpInside)
    }

    private func moveCameraToLocation() {
        guard let latitude = mapView.myLocation?.coordinate.latitude,
              let longitude = mapView.myLocation?.coordinate.longitude
        else { return }

        let camera = GMSCameraPosition.camera(
            withLatitude: latitude,
            longitude: longitude,
            zoom: 10
        )

        mapView.animate(to: camera)
    }

    private func clearButtonSetup() {
        clearButton.isHidden = true

        clearButton.setImage(nil, for: .normal)
        view.insertSubview(clearButton, aboveSubview: mapView)

        clearButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().inset(10)
            $0.size.equalTo(56)
        }

        clearButton.addTarget(self, action: #selector(clearLocation), for: .touchUpInside)
    }

    @objc private func clearLocation() {
        viewModel.markerState = .start
        titleLabel.text = viewModel.markerState.text
        selectLocation.setTitle("Выбрать точку", for: .normal)
        viewModel.markerA?.map = nil
        viewModel.markerB?.map = nil
    }

    @objc private func selectLcoation() {
        switch viewModel.markerState {
        case .start:
            let marker = GMSMarker()
            marker.position = mapView.camera.target
            marker.map = mapView
            marker.title = "От"
            viewModel.markerA = marker
            viewModel.markerState = .end
            titleLabel.text = viewModel.markerState.text
        case .end:
            let marker = GMSMarker()
            marker.position = mapView.camera.target
            marker.map = mapView
            marker.title = "До"
            viewModel.markerB?.map = nil
            viewModel.markerB = marker
            viewModel.markerState = .go
            titleLabel.text = ""
            selectLocation.setTitle(viewModel.markerState.text, for: .normal)
        case .go:
            Task {
                await viewModel.startTravel()
            }
        }
    }
}

extension MapController: GMSMapViewDelegate {

}

extension MapController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        textField.resignFirstResponder()

        Task {
            await viewModel.geocodeLocation(address: textField.text ?? "")
        }
        return true
    }
}

import UIKit

public extension UIColor {
    @frozen
    enum Error: Swift.Error {
        case wrongColorFormat(format: String)
        case wrongRGBAComponent(format: String)
    }

    convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat = 1) {
        func validated(component value: Int) -> CGFloat {
            guard value > 0 else {
                return 0
            }
            guard value < 256 else {
                return 255
            }
            return CGFloat(value) / 255.0
        }
        func validated(alphaComponent value: CGFloat) -> CGFloat {
            max(min(value, 1.0), 0)
        }
        let redValidated = validated(component: red)
        let greenValidated = validated(component: green)
        let blueValidated = validated(component: blue)
        let alphaValidated = validated(alphaComponent: alpha)
        self.init(red: redValidated, green: greenValidated, blue: blueValidated, alpha: alphaValidated)
    }

    convenience init(hex: Int) {
        self.init(
            red: (hex >> 16) & 0xff,
            green: (hex >> 8) & 0xff,
            blue: hex & 0xff
        )
    }

    /**
     Supported formats:
     - hex: "fff", "#fff", "0xFFF"
     - hex with alpha: "FFFFFF11", "0xFFFFFFFF11", "#FFFFFF11"
     */
    convenience init(hexString: String) throws {
        var hexTrimmed = hexString
            .trimmingCharacters(in: CharacterSet.whitespaces)
            .replacingOccurrences(of: "0x", with: "")
            .replacingOccurrences(of: "#", with: "")
        switch hexTrimmed.count {
        case 3:
            // short hex: "#fff"
            hexTrimmed = hexTrimmed.map(String.init).map({ $0 + $0 }).joined()
            fallthrough
        case 6, 8:
            // default hex: "#ffffff"
            // or hex with alpha: "#ffffffff"

            var hexSanitized = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
            hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

            var rgb: UInt64 = 0

            var red: CGFloat = 0.0
            var green: CGFloat = 0.0
            var blue: CGFloat = 0.0
            var alpha: CGFloat = 1.0

            guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else {
                throw Error.wrongColorFormat(format: hexSanitized)
            }

            if hexTrimmed.count == 6 {
                red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
                green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
                blue = CGFloat(rgb & 0x0000FF) / 255.0
            } else {
                red = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
                green = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
                blue = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
                alpha = CGFloat(rgb & 0x000000FF) / 255.0
            }
            self.init(red: red, green: green, blue: blue, alpha: alpha)

        default:
            throw Error.wrongColorFormat(format: hexString)
        }
    }

    /**
     Supported formats:
     - RBG: ""0, 153, 204", "0,255,0"
     - RGBA: "102, 0, 255, 0.5", 102,0,255,0.3"
     */
    convenience init(rgbaString: String) throws {
        let componentStrings = rgbaString
            .replacingOccurrences(of: " ", with: "")
            .split(separator: ",")
            .map(String.init)
        guard [3, 4].contains(componentStrings.count) else {
            throw Error.wrongColorFormat(format: rgbaString)
        }
        func rgbComponent(_ value: String) throws -> Int {
            guard let val = Int(value) else {
                throw Error.wrongRGBAComponent(format: value)
            }
            return val
        }
        func alphaComponent(_ value: String) throws -> CGFloat {
            guard let val = Double(value) else {
                throw Error.wrongRGBAComponent(format: value)
            }
            return CGFloat(val)
        }
        if componentStrings.count == 3 {
            self.init(
                red: try rgbComponent(componentStrings[0]),
                green: try rgbComponent(componentStrings[1]),
                blue: try rgbComponent(componentStrings[2])
            )
        } else {
            self.init(
                red: try rgbComponent(componentStrings[0]),
                green: try rgbComponent(componentStrings[1]),
                blue: try rgbComponent(componentStrings[2]),
                alpha: try alphaComponent(componentStrings[3])
            )
        }
    }
}
