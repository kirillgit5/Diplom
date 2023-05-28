public struct DirectionResponse: Decodable {
    public struct Routes: Decodable {
        public struct Legs: Decodable {
            public struct Steps: Decodable {
                public struct Polyline: Decodable {
                    public let points: String
                }

                public let polyline: Polyline
            }

            public var steps: Array<Steps>
        }

        public let legs: Array<Legs>
    }

    public let routes: Array<Routes>?
}
