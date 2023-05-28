import SwiftUI

public struct Placeholder<T: View>: ViewModifier {
    private let placeholder: T
    private let needShow: Bool

    public init(
        placeholder: T,
        needShow: Bool
    ) {
        self.placeholder = placeholder
        self.needShow = needShow
    }

    public func body(content: Content) -> some View {
        ZStack(alignment: .leading) {
            if needShow {
                placeholder
            }
            content
        }
    }
}

public extension View {
    func placeholder<T: View>(_ holder: T, needShow: Bool) -> some View {
        modifier(Placeholder(placeholder: holder, needShow: needShow))
    }
}
