public struct CreateDriverParams: Encodable {
    public struct Calories: Encodable {
        public struct Point: Encodable {
            public let lat: Double?
            public let lng: Double?

            public init(lat: Double?, lng: Double?) {
                self.lat = lat
                self.lng = lng
            }
        }

        public let startPoint: Point
        public let endPoint: Point

        public init(startPoint: Point, endPoint: Point) {
            self.startPoint = startPoint
            self.endPoint = endPoint
        }
    }

    public let id: String?
    public let calories: Calories
    public let status: String?

    public init(id: String?, calories: Calories, status: String?) {
        self.id = id
        self.calories = calories
        self.status = status
    }
}
