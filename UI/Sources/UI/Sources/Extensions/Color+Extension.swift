import SwiftUI

public extension Color {
    enum Background {
        public static var primary: Color { color(light: Palette.Gray.gray0, dark: Palette.Gray.gray0) }
        public static var tertiaryBlur: Color { color(light: Palette.Gray.gray900, dark: Palette.Gray.gray900) }
        public static var darkBlur: Color { color(light: Palette.Gray.gray1000, dark: Palette.Gray.gray1000) }
        public static var accentPrimary: Color { color(light: Palette.Green.green0, dark: Palette.Green.green0) }
    }

    enum Content {
        public static var primary: Color { color(light: Palette.Gray.gray800, dark: Palette.Gray.gray800) }
        public static var tertiary: Color { color(light: Palette.Gray.gray250, dark: Palette.Gray.gray250) }
        public static var accentPrimary: Color { color(light: Palette.Green.green0, dark: Palette.Green.green0) }
    }

    enum Controls {
        public static var primary: Color { color(light: Palette.Green.green0, dark: Palette.Green.green0) }
        public static var primaryDisabled: Color { color(light: Palette.Green.green100, dark: Palette.Green.green100) }
        public static var primaryEdit: Color { color(light: Palette.Gray.gray0, dark: Palette.Gray.gray0) }
        public static var disabled: Color { color(light: Palette.Gray.gray250, dark: Palette.Gray.gray250) }
        public static var secondary: Color { color(light: Palette.Gray.gray100, dark: Palette.Gray.gray100) }
    }

    enum Error {
        public static var primary: Color { color(light: Palette.Red.red100, dark: Palette.Red.red100) }
    }

    private static func color(light: Color, dark: Color) -> Color {
        switch UIScreen.main.traitCollection.userInterfaceStyle {
        case .dark: return dark
        case .light: return light
        default: return light
        }
    }
}

extension Color {
    init(_ hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}
