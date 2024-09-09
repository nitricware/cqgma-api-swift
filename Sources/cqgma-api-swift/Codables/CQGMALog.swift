import Foundation

public struct CQGMALog: CQGMAAPIPayload {
    public let USER: String
    public let PSWD: String
    public let DUMP: Int
    public let LIVE: Int
    public let LOGC: Int
    public let QSO: [CQGMAQSO]
}
