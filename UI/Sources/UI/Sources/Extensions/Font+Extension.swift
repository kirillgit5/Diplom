import SwiftUI

public extension Font {
    static func title1() -> Font {
        Font.custom(Typography.medium, size: 28)
    }

    static func caption1() -> Font {
        Font.custom(Typography.regular, size: 12)
    }

    static func body1() -> Font {
        Font.custom(Typography.regular, size: 16)
    }

    static func body3() -> Font {
        Font.custom(Typography.regular, size: 15)
    }

    static func headline() -> Font {
        Font.custom(Typography.regular, size: 18)
    }

    static func body4() -> Font {
        Font.custom(Typography.regular, size: 11)
    }
}
