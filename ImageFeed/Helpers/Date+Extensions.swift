import Foundation

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    formatter.dateFormat = "dd MMMM yyyy"
    return formatter
}()

private let dateFormatterISO: ISO8601DateFormatter = {
    ISO8601DateFormatter()
}()

extension Date {
    var dateTimeString: String { dateFormatter.string(from: self) }
    
    static func convertStringToDate(_ string: String) -> Date? {
       dateFormatterISO.date(from: string)
    }
}
