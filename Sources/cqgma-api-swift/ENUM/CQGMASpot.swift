import Foundation

/// A CQGMASpot
/// Each spot contains the following fields
/// -- DATE          String "YYYYMMDD"                  ->      transformed to DATETIME: Date
/// -- TIME          String "HHMM"                      ->      transformed to DATETIME: Date
/// -- SPOTTER       String "CALLSIGN"
/// -- ACTIVATOR     String "CALLSIGN"
/// -- TEXT          String
/// -- REF           String "GMA-REF"                   ->      transformed to REF: CQGMARef?
/// -- QRG           String could contain an actual     ->      transformed to QRG: Double
///                         frequency, or some
///                         arbitrary String
/// -- MODE          String "MDDE"
/// -- LAT           String could countain a Double     ->      transformed to LAT: Double
///                         describing the latitude
///                         or no value at all
/// -- LON           String could countain a Double     ->      transformed to LON: Double
///                         describing the longitude
///                         or no value at all
/// -- NAME          String "GMA-NAME"
///
/// - throws: DecodingError.typeMismatch` if the encountered encoded value
///   is not convertible to the requested type.
/// - throws: `DecodingError.keyNotFound` if `self` does not have an entry
///   for the given key.
/// - throws: `DecodingError.valueNotFound` if `self` has a null entry for
///   the given key.
@available(macOS 13.0, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public struct CQGMASpot: Decodable {
    public let DATETIME: Date?
    public let SPOTTER: String
    public let ACTIVATOR: String
    public let TEXT: String
    public let REF: String?
    public var REFOBJ: CQGMARef?
    public let QRG: Double?
    public let MODE: String
    public let LAT: Double?
    public let LON: Double?
    public let NAME: String
    
    private enum CodingKeys: String, CodingKey {
        case DATE
        case TIME
        case SPOTTER
        case ACTIVATOR
        case TEXT
        case REF
        case REFOBJ
        case QRG
        case MODE
        case LAT
        case LON
        case NAME
    }
    
    public init (from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let dateString = try container.decode(String.self, forKey: .DATE)
        let timeString = try container.decode(String.self, forKey: .TIME)
        let qrgString = try container.decode(String.self, forKey: .QRG)
        let latString = try container.decode(String.self, forKey: .LAT)
        let lonString = try container.decode(String.self, forKey: .LON)

        let datetime = CQGMAHelper.getDate(dateString: dateString, timeString: timeString)
        
        self.DATETIME = datetime
        self.SPOTTER = try container.decode(String.self, forKey: .SPOTTER)
        self.ACTIVATOR = try container.decode(String.self, forKey: .ACTIVATOR)
        self.TEXT = try container.decode(String.self, forKey: .TEXT)
        self.REF = try container.decodeIfPresent(String.self, forKey: .REF)
        self.REFOBJ = try container.decodeIfPresent(CQGMARef.self, forKey: .REFOBJ)
        self.QRG = Double(qrgString)
        self.MODE = try container.decode(String.self, forKey: .MODE)
        self.LAT = Double(latString)
        self.LON = Double(lonString)
        self.NAME = try container.decode(String.self, forKey: .NAME)
    }
}
