import Foundation

public struct CQGMASendSpotResponse: CQGMAAPIResponse {
    public var CHECKLOG: String
    public var DUMP: Bool?
    public var Inserted_Spots: Int
    public var MYCALL_ERROR: String
    public var REF_ERROR: String
    public var EXIT_ERROR: String
    
    enum CodingKeys: String, CodingKey {
        case CHECKLOG
        case DUMP
        case Inserted_Spots
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
        
        Inserted_Spots = Int(try values.decode(String.self, forKey: .Inserted_Spots)) ?? 0
        
        MYCALL_ERROR = try values.decode(String.self, forKey: .MYCALL_ERROR)
        REF_ERROR = try values.decode(String.self, forKey: .REF_ERROR)
        EXIT_ERROR = try values.decode(String.self, forKey: .EXIT_ERROR)
    }
}
