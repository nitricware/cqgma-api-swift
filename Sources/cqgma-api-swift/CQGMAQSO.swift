import Foundation

public struct CQGMAQSO: CQGMAAPIPayload {
    public let ID: UUID?
    public var DATETIME: Date?
    public var MYCALL: String?
    public var OPERATOR: String?
    public var MYLOC: String?
    public var MAINREF: String?                 // TODO: Require CQGMAReference object
    public var XREF1: String?
    public var XREF2: String?
    public var XREF3: String?
    public var XREF4: String?
    public var WKDCALL: String?
    public var MHZ: Double?
    public var BAND: String?
    public var MODE: String?
    public var RSTS: String?
    public var RSTR: String?
    public var LOCATOR: String?
    public var WKDREF: String?                  // TODO: Require CQGMAReference object
    public var PROPAGATION: String?
    public var REMARKS: String?
    public var ACTION: CQGMALoggingAction
    public var WKDDXCC: String?
    public var SATNAME: String?
    public var SATMODE: String?
    
    private enum CodingKeys: String, CodingKey {
        case ID
        case DATE
        case UTC
        case MYCALL
        case OPERATOR
        case MYLOC
        case MAINREF
        case XREF1
        case XREF2
        case XREF3
        case XREF4
        case WKDCALL
        case MHZ
        case BAND
        case MODE
        case RSTS
        case RSTR
        case LOCATOR
        case WKDREF
        case ACTION
        case WKDDXCC
        case SATNAME
        case SATMODE
    }
    
    public init(
        activation ID: UUID = UUID(),
        DATETIME: Date = Date(),
        MYCALL: String,
        MYLOC: String,
        MAINREF: String,
        WKDCALL: String,
        MHZ: Double,
        MODE: String,
        RSTS: String,
        RSTR: String,
        ACTION: CQGMALoggingAction = .Add
    ) {
        self.ID = ID
        self.DATETIME = DATETIME
        self.MYCALL = MYCALL
        self.MYLOC = MYLOC
        self.MAINREF = MAINREF
        self.WKDCALL = WKDCALL
        self.MHZ = MHZ
        self.MODE = MODE
        self.RSTS = RSTS
        self.RSTR = RSTR
        self.ACTION = ACTION
    }
    
    public init(
        chase ID: UUID = UUID(),
        DATETIME: Date = Date(),
        MYCALL: String,
        MYLOC: String,
        WKDCALL: String,
        MHZ: Double,
        MODE: String,
        RSTS: String,
        RSTR: String,
        WKDREF: String,
        ACTION: CQGMALoggingAction = .Add
    ) {
        self.ID = ID
        self.DATETIME = DATETIME
        self.MYCALL = MYCALL
        self.MYLOC = MYLOC
        self.WKDCALL = WKDCALL
        self.MHZ = MHZ
        self.MODE = MODE
        self.RSTS = RSTS
        self.RSTR = RSTR
        self.WKDREF = WKDREF
        self.ACTION = ACTION
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        var dateString: String
        var timeString: String
        
        let dateFormatter = DateFormatter()
        
        if let uuid = self.ID {
            try container.encode(uuid.uuidString, forKey: .ID)
        } else {
            try container.encode(UUID().uuidString, forKey: .ID)
        }
        
        if let date = DATETIME {
            dateFormatter.dateFormat = "yyyyMMdd"
            dateString = dateFormatter.string(from: date)
            try container.encode(dateString, forKey: .DATE)
            
            dateFormatter.dateFormat = "HHmm"
            timeString = dateFormatter.string(from: date)
            try container.encode(timeString, forKey: .UTC)
        }
        
        try container.encodeIfPresent(self.MYCALL, forKey: .MYCALL)
        try container.encodeIfPresent(self.OPERATOR, forKey: .OPERATOR)
        try container.encodeIfPresent(self.MYLOC, forKey: .MYLOC)
        try container.encodeIfPresent(self.MAINREF, forKey: .MAINREF)
        try container.encodeIfPresent(self.XREF1, forKey: .XREF1)
        try container.encodeIfPresent(self.XREF2, forKey: .XREF2)
        try container.encodeIfPresent(self.XREF3, forKey: .XREF3)
        try container.encodeIfPresent(self.XREF4, forKey: .XREF4)
        try container.encodeIfPresent(self.WKDCALL, forKey: .WKDCALL)
        
        if let mhz = self.MHZ {
            try container.encodeIfPresent(String(mhz), forKey: .MHZ)
        }
        
        try container.encodeIfPresent(self.BAND, forKey: .BAND)
        try container.encodeIfPresent(self.MODE, forKey: .MODE)
        try container.encodeIfPresent(self.RSTS, forKey: .RSTS)
        try container.encodeIfPresent(self.RSTR, forKey: .RSTR)
        try container.encodeIfPresent(self.LOCATOR, forKey: .LOCATOR)
        try container.encodeIfPresent(self.WKDREF, forKey: .WKDREF)
        
        try container.encode(self.ACTION.rawValue, forKey: .ACTION)
        
        try container.encode(self.WKDDXCC, forKey: .WKDDXCC)
        try container.encode(self.SATNAME, forKey: .SATNAME)
        try container.encode(self.SATMODE, forKey: .SATMODE)
    }
}
