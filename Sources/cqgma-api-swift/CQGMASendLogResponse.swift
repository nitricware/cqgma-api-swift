import Foundation
/*
 {"CHECKLOG":"all fine","DUMP":"is off","LIVE":"is
 off","ACTQSOINS":"0","ACTQSOUPD":"0","ACTQSODEL":"0","CHSQSOINS":"0","CHSQSOUPD":"0","CHSQSODEL":"0"
 ,"MYCALL_ERROR":"NONE","REF_ERROR":"NONE","EXIT_ERROR":"NONE"}
 */

public struct CQGMASendLogResponse: CQGMAAPIResponse {
    public var CHECKLOG: String
    public var DUMP: Bool?
    public var LIVE: Bool?
    public var ACTQSOINS: Int
    public var ACTQSODEL: Int
    public var CHSQSOINS: Int
    public var CHSQSOUPD: Int
    public var CHSQSODEL: Int
    public var MYCALL_ERROR: String
    public var REF_ERROR: String
    public var EXIT_ERROR: String
    
    enum CodingKeys: String, CodingKey {
        case CHECKLOG
        case DUMP
        case LIVE
        case ACTQSOINS
        case ACTQSODEL
        case CHSQSOINS
        case CHSQSOUPD
        case CHSQSODEL
        case MYCALL_ERROR
        case REF_ERROR
        case EXIT_ERROR
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        CHECKLOG = try values.decode(String.self, forKey: .CHECKLOG)
        
        if let dump = Bool(try values.decode(String.self, forKey: .DUMP) == "is on" ? "true" : "false") {
            self.DUMP = dump
        }
        
        if let live = Bool(try values.decode(String.self, forKey: .LIVE) == "is on" ? "true" : "false") {
            self.LIVE = live
        }
        
        ACTQSOINS = Int(try values.decode(String.self, forKey: .ACTQSOINS)) ?? 0
        ACTQSODEL = Int(try values.decode(String.self, forKey: .ACTQSODEL)) ?? 0
        CHSQSOINS = Int(try values.decode(String.self, forKey: .CHSQSOINS)) ?? 0
        CHSQSOUPD = Int(try values.decode(String.self, forKey: .CHSQSOUPD)) ?? 0
        CHSQSODEL = Int(try values.decode(String.self, forKey: .CHSQSODEL)) ?? 0
        
        MYCALL_ERROR = try values.decode(String.self, forKey: .MYCALL_ERROR)
        REF_ERROR = try values.decode(String.self, forKey: .REF_ERROR)
        EXIT_ERROR = try values.decode(String.self, forKey: .EXIT_ERROR)
    }
}
