import Foundation

public struct CQGMAHelper {
    public static func getDate(dateString: String, timeString: String) -> Date? {
        if dateString.count != 8 || timeString.count != 4 {
            return nil
        }
        
        let dateFormatter = ISO8601DateFormatter()
        
        let y = dateString[dateString.startIndex...dateString.index(dateString.startIndex, offsetBy: 3)]
        let m = dateString[dateString.index(dateString.startIndex, offsetBy: 4)...dateString.index(dateString.startIndex, offsetBy: 5)]
        let d = dateString[dateString.index(dateString.startIndex, offsetBy: 6)...dateString.index(dateString.startIndex, offsetBy: 7)]
        
        let h = timeString[timeString.startIndex...timeString.index(timeString.startIndex, offsetBy: 1)]
        let i = timeString[timeString.index(timeString.startIndex, offsetBy: 2)...timeString.index(timeString.startIndex, offsetBy: 3)]
        
        let isoDate = "\(y)-\(m)-\(d)T\(h):\(i):00+0000"
        
        if let returnDate = dateFormatter.date(from: isoDate) {
            return returnDate
        }
        
        return nil
    }
    
    public static func getDate(dateString: String) -> Date? {
        if dateString.count != 8 {
            return nil
        }
        
        let dateFormatter = ISO8601DateFormatter()
        
        let y = dateString[dateString.startIndex...dateString.index(dateString.startIndex, offsetBy: 3)]
        let m = dateString[dateString.index(dateString.startIndex, offsetBy: 4)...dateString.index(dateString.startIndex, offsetBy: 5)]
        let d = dateString[dateString.index(dateString.startIndex, offsetBy: 6)...dateString.index(dateString.startIndex, offsetBy: 7)]
         
        let isoDate = "\(self.checkDateComponent(year: y))-\(self.checkDateComponent(month:m))-\(self.checkDateComponent(day:d))T00:00:00+0000"
        
        if let returnDate = dateFormatter.date(from: isoDate) {
            return returnDate
        }
        
        return nil
    }
    
    private static func checkDateComponent(month:String.SubSequence) -> String {
        guard let m = Int(month) else {
            return "01"
        }
        
        if m < 1 || m > 12 {
            return "01"
        }
        
        return String(format: "%02d", m)
    }
    
    private static func checkDateComponent(day:String.SubSequence) -> String {
        guard let d = Int(day) else {
            return "01"
        }
        
        if d < 1 || d > 31 {
            return "01"
        }
        
        return String(format: "%02d", d)
    }
    
    private static func checkDateComponent(year:String.SubSequence) -> String {
        guard let y = Int(year) else {
            return "9999"
        }
        
        if y < 0 || y > 9999 {
            return "9999"
        }
        
        return String(format: "%04d", y)
    }
}
