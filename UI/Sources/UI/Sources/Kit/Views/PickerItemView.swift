import SwiftUI

struct PickerItemView: View {
    //    private let title: String
    //    private let description: String
    //    @Binding private var isOn: Bool
    //    private let rightImage: UIImage?

    private let model: Model

    init(model: Model) {
        self.model = model
    }

    public var body: some View {
        HStack(alignment: .center) {
            RadioButton(isOn: model.isOn)
                .disabled(true)
            Spacer()
                .frame(width: 24)
            VStack(alignment: .leading) {
                Text(model.title)
                    .font(.headline())
                    .foregroundColor(.Content.primary)
                Text(model.description)
                    .font(.body3())
                    .foregroundColor(.Content.tertiary)
            }

            Spacer()

            if let image = model.rightImage {
                Image(uiImage: image)
                    .frame(width: 24, height: 24)
                    .cornerRadius(12)
            }
        }
        .padding(.init(top: 16, leading: 0, bottom: 16, trailing: 0))
        .onTapGesture { model.isOn.wrappedValue = true }
    }
}

extension PickerItemView {
    struct Model {
        let title: String
        let description: String
        var isOn: Binding<Bool>
        let rightImage: UIImage?
    }
}
