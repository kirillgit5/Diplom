import Foundation

struct RegistrationFormStateBuilder {

    private var dateRange: ClosedRange<Date> {
        guard let startDate = Calendar.current.date(byAdding: .year, value: -100, to: Date()) else { return Date()...Date() }

        return startDate...Date()
    }

    init() {}

    func buildInitialState() -> RegistrationFormReducer.State {
        .init(
            fieldsModel: .init(),
            dateSelectorState: .collapse,
            dateRange: dateRange,
            selectedDateText: "dd/MM/yyyy",
            selectedDate: Date()
        )
    }
}
