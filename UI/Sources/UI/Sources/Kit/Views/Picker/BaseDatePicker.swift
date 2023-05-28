import SwiftUI

public struct BaseDatePicker: View {
    @Binding var date: Date

    private let dateRange: ClosedRange<Date>
    private let components: DatePickerComponents

    public init(
        date: Binding<Date>,
        dateRange: ClosedRange<Date>,
        components: DatePickerComponents = [.date]
    ) {
        self._date = date
        self.dateRange = dateRange
        self.components = components
    }

    public var body: some View {
        VStack {
            DatePicker(
                "",
                selection: $date,
                in: dateRange,
                displayedComponents: components
            )
            .labelsHidden()
            .datePickerStyle(.wheel)
            .labelsHidden()
        }
    }
}
