import SwiftUI

enum Palette {
    enum Gray {
        static let gray0 = Color(0xFFFFFF)
        static let gray250 = Color(0x9A9B9D)
        static let gray800 = Color(0x1C1E24)
        static let gray900 = Color(0x000000, alpha: 0.24)
        static let gray1000 = Color(0x000000, alpha: 0.5)
        static let gray100 = Color(0xF5F5F5)
    }

    enum Green {
        static let green0 = Color(0x34D5DC)
        static let green100 = Color(0x34D5DC, alpha: 0.4)
    }

    enum Red {
        static let red100 = Color(0xFF1313)
    }

    enum Shadow {
        static let base1 = Color(0x4E4E4E, alpha: 0.065)
    }
}
