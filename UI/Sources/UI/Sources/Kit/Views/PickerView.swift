import SwiftUI
import Core

public struct PickerView: View {
    private let model: Model

    public init(model: Model) {
        self.model = model
    }

    public var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(model.items) { item in
                    PickerItemView(
                        model: .init(
                            title: item.title,
                            description: item.description,
                            isOn: Binding(
                                get: { model.selectedItem.wrappedValue == item.id },
                                set: { _ in model.selectedItem.wrappedValue = item.id }
                            ),
                            rightImage: item.rightImage
                        )
                    )
                    if item.id != model.items.last?.id {
                        Divider()
                    }
                }
            }
            .padding()
        }
    }
}

public extension PickerView {
    struct Model {
        let items: [PickerItem]
        var selectedItem: Binding<String>

        public init(items: [PickerItem], selectedItem: Binding<String>) {
            self.items = items
            self.selectedItem = selectedItem
        }
    }
}

public struct PickerItem: Identifiable {
    public let id: String
    let title: String
    let description: String
    let rightImage: UIImage?

    public init(id: String, title: String, description: String, rightImage: UIImage? = nil) {
        self.id = id
        self.title = title
        self.description = description
        self.rightImage = rightImage
    }
}
