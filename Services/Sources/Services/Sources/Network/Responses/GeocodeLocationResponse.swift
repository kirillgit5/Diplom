public struct GeocodeLocationResponse: Decodable {
    public struct Result: Decodable {
        public struct Geometry: Decodable {
            public struct Location: Decodable {
                public let lat: Double
                public let lng: Double
            }

            public let location: Location
        }

        public let formatted_address: String?
        public let geometry: Geometry
    }

    public let results: Array<Result>?
}
