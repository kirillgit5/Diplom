import Foundation

public extension Date {
    private static let formatter: DateFormatter = DateFormatter()

    enum Format {
        /// 17/11/2022
        case daySlashMonthSlashYear

        public var stringFormat: String {
            switch self {
            case .daySlashMonthSlashYear: return "dd/MM/yyyy"
            }
        }
    }

    func stringRepresentation(with format: Format, locale: Locale = Locale.current) -> String {
        let dateFormatter = Date.formatter
        dateFormatter.locale = locale
        dateFormatter.dateFormat = format.stringFormat
        return dateFormatter.string(from: self)
    }

    static func dateFrom(string: String, format: Format) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = format.stringFormat
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")

        guard let date = dateFormatter.date(from: string) else {
            return nil
        }

        return date
    }
}
