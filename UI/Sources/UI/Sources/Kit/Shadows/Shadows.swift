import SwiftUI

public extension View {
    func shadowDrop1() -> some View {
        self.background(
            Palette.Shadow.base1
                .shadow(color: Palette.Shadow.base1, radius: 16, x: 0, y: -4)
                .blur(radius: 20)
        )
    }

    func shadowDrop2() -> some View {
        self.background(
            Palette.Shadow.base1
                .shadow(color: Palette.Shadow.base1, radius: 10, x: 0, y: -5)
                .blur(radius: 10)
        )
    }
}
