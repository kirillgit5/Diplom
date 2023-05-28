public struct CompanionFindParams: Encodable {
    public struct Route: Encodable {
        public struct StartPoint: Encodable {
            public let lat: Double?
            public let lng: Double?

            public init(lat: Double?, lng: Double?) {
                self.lat = lat
                self.lng = lng
            }
        }

        public let startPoint: StartPoint?
        public let endPoint: StartPoint?

        public init(startPoint: StartPoint?, endPoint: StartPoint?) {
            self.startPoint = startPoint
            self.endPoint = endPoint
        }
    }

    public let route: Route?
    public let time: Int?
    public let percent: Int?

    public init(route: Route?, time: Int?, percent: Int?) {
        self.route = route
        self.time = time
        self.percent = percent
    }
}
