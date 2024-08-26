import Foundation

public struct CQGMARef: Decodable, CQGMAApiType {
    public var reftype: CQGMARefType            //                      -   available in all refs
    public var ref: String?
    public var dxcc: String?
    public var height: Int?                     // deviation to JSON
    public var sota_points: Int?                // deviation to JSON
    public var longitude: Double                // deviation to JSON    -   available in all refs
    public var latitude: Double                 // deviation to JSON    -   available in all refs
    public var name: String                     //                      -   available in all refs
    public var deleted: Bool?                   // deviation to JSON
    public var region: String?
    public var wwff: String?
    public var valid_from: Date?                // deviation to JSON    -   available in all refs
    public var valid_to: Date?                  // deviation to JSON    -   available in all refs
    public var sota_valid_from: Date?           // deviation to JSON
    public var sota_valid_to: Date?             // deviation to JSON
    public var sota_deleted: Bool?              // deviation to JSON
    public var sota_again: String?
    public var assn_name: String?
    public var region_name: String?
    public var bonus_points: Int?               // deviation to JSON
    public var act_count: Int?
    public var act_date: Date?                  // deviation to JSON
    public var act_call: String?
    public var drive_on: Bool?                  // deviation to JSON
    public var locator: String?                 //                      -   available in all refs
    public var location: String?
    public var pfx: String?
    public var reg: String?
    public var sota: String?
    public var iota: String?                    //                      -   available in all refs but can be "null"
    public var gma_island: String?
    public var wlota: String?
    public var cota: String?
    public var wca: String?
    public var tower: Bool?                     // deviation to JSON
    public var tower_category: Int?             // deviation to JSON
    public var tower_height: Int?               // deviation to JSON
    public var tower_name: String?
    public var bwn: Bool?                       // deviation to JSON
    public var sbw: Bool?                       // deviation to JSON
    public var wheelchair: Bool?                // deviation to JSON
    public var mountain_hut: Bool?              // deviation to JSON
    public var mountain_hut_name: String?
    public var shelter: Bool?                   // deviation to JSON
    public var picnic: Bool?                    // deviation to JSON
    public var webcam: String?
    public var trig: String?
    public var hump: String?
    public var wikipedia: URL?
    public var maplink: String?
    public var mill: String?
    public var url: URL?
    public var comment: String?
    public var arlhs: String?
    public var awardflag: String?
    public var illw: String?
    public var wac: String?
    public var district: String?
    public var function: String?
    public var state: String?
    public var ruin: Bool?                      // deviation to JSON
    public var type: Int?                       // deviation to JSON
    public var lat2: Double?                    // deviation to JSON
    public var lng2: Double?                    // deviation to JSON
    
    
    private enum CodingKeys: String, CodingKey {
        case reftype
        case ref
        case dxcc
        case height
        case sota_points
        case longitude
        case latitude
        case name
        case deleted
        case region
        case wwff
        case valid_from
        case valid_to
        case sota_valid_from
        case sota_valid_to
        case sota_deleted
        case sota_again
        case assn_name
        case region_name
        case bonus_points
        case act_count
        case act_date
        case act_call
        case drive_on
        case locator
        case location
        case pfx
        case reg
        case sota
        case iota
        case gma_island
        case wlota
        case cota
        case wca
        case tower
        case tower_category
        case tower_height
        case tower_name
        case bwn
        case sbw
        case wheelchair
        case mountain_hut
        case mountain_hut_name
        case shelter
        case picnic
        case webcam
        case trig
        case hump
        case wikipedia
        case maplink
        case mill
        case url
        case comment
        case arlhs
        case awardflag
        case illw
        case wac
        case district
        case function
        case state
        case ruin
        case type
        case lat2
        case lng2
    }
    
    public init (from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.reftype = CQGMARefType(rawValue: try container.decode(String.self, forKey: .reftype)) ?? CQGMARefType.Unknown
        self.ref = try container.decodeIfPresent(String.self, forKey: .ref)
        self.dxcc = try container.decodeIfPresent(String.self, forKey: .dxcc)
        
        if let height = try container.decodeIfPresent(String.self, forKey: .height) {
            self.height = Int(height)
        }
        
        if let sota_points = try container.decodeIfPresent(String.self, forKey: .sota_points) {
            self.sota_points = Int(sota_points)
        }
        
        self.longitude = Double(try container.decode(String.self, forKey: .longitude))!
        self.latitude = Double(try container.decode(String.self, forKey: .latitude))!
        self.name = try container.decode(String.self, forKey: .name)
        
        if let deleted = try container.decodeIfPresent(String.self, forKey: .deleted) {
            self.deleted = Bool(deleted == "0" ? "false" : "true")
        }
        
        self.region = try container.decodeIfPresent(String.self, forKey: .region)
        self.wwff = try container.decodeIfPresent(String.self, forKey: .wwff)
        
        if let valid_from = try container.decodeIfPresent(String.self, forKey: .valid_from) {
            self.valid_from = CQGMAHelper.getDate(dateString: valid_from)
        }
        
        if let valid_to = try container.decodeIfPresent(String.self, forKey: .valid_to) {
            self.valid_to = CQGMAHelper.getDate(dateString: valid_to)
        }
        
        if let sota_valid_from = try container.decodeIfPresent(String.self, forKey: .sota_valid_from) {
            self.sota_valid_from = CQGMAHelper.getDate(dateString: sota_valid_from)
        }
        
        if let sota_valid_to = try container.decodeIfPresent(String.self, forKey: .sota_valid_to) {
            self.sota_valid_to = CQGMAHelper.getDate(dateString: sota_valid_to)
        }
        
        if let sota_deleted = try container.decodeIfPresent(String.self, forKey: .sota_deleted) {
            self.sota_deleted = Bool(sota_deleted == "0" ? "false" : "true")
        }
        
        self.sota_again = try container.decodeIfPresent(String.self, forKey: .sota_again)
        self.assn_name = try container.decodeIfPresent(String.self, forKey: .assn_name)
        self.region_name = try container.decodeIfPresent(String.self, forKey: .region_name)
        
        if let bonus_points = try container.decodeIfPresent(String.self, forKey: .bonus_points) {
            self.bonus_points = Int(bonus_points)
        }
        
        if let act_count = try container.decodeIfPresent(String.self, forKey: .act_count) {
            self.act_count = Int(act_count)
        }
        
        if let act_date = try container.decodeIfPresent(String.self, forKey: .act_date) {
            self.act_date = CQGMAHelper.getDate(dateString: act_date)
        }
        
        self.act_call = try container.decodeIfPresent(String.self, forKey: .act_call)
        
        if let drive_on = try container.decodeIfPresent(String.self, forKey: .drive_on) {
            self.drive_on = Bool(drive_on == "N" ? "false" : "true")
        }
        
        self.locator = try container.decodeIfPresent(String.self, forKey: .locator)
        
        self.location = try container.decodeIfPresent(String.self, forKey: .location)
        self.pfx = try container.decodeIfPresent(String.self, forKey: .pfx)
        self.reg = try container.decodeIfPresent(String.self, forKey: .reg)
        self.sota = try container.decodeIfPresent(String.self, forKey: .sota)
        self.iota = try container.decodeIfPresent(String.self, forKey: .iota)
        self.gma_island = try container.decodeIfPresent(String.self, forKey: .gma_island)
        self.wlota = try container.decodeIfPresent(String.self, forKey: .wlota)
        self.cota = try container.decodeIfPresent(String.self, forKey: .cota)
        self.wca = try container.decodeIfPresent(String.self, forKey: .wca)
        
        if let tower = try container.decodeIfPresent(String.self, forKey: .tower) {
            self.tower = Bool(tower == "N" ? "false" : "true")
        }
        
        if let tower_category = try container.decodeIfPresent(String.self, forKey: .tower_category) {
            self.tower_category = Int(tower_category)
        }
        
        if let tower_height = try container.decodeIfPresent(String.self, forKey: .tower_height) {
            self.tower_height = Int(tower_height)
        }
        
        self.tower_name = try container.decodeIfPresent(String.self, forKey: .tower_name)
        
        if let bwn = try container.decodeIfPresent(String.self, forKey: .bwn) {
            self.bwn = Bool(bwn == "N" ? "false" : "true")
        }
        
        if let sbw = try container.decodeIfPresent(String.self, forKey: .sbw) {
            self.sbw = Bool(sbw == "N" ? "false" : "true")
        }
        
        if let wheelchair = try container.decodeIfPresent(String.self, forKey: .wheelchair) {
            self.wheelchair = Bool(wheelchair == "0" ? "false" : "true")
        }
        
        if let mountain_hut = try container.decodeIfPresent(String.self, forKey: .mountain_hut) {
            self.mountain_hut = Bool(mountain_hut == "N" ? "false" : "true")
        }
        
        self.mountain_hut_name = try container.decodeIfPresent(String.self, forKey: .mountain_hut_name)
        
        if let shelter = try container.decodeIfPresent(String.self, forKey: .shelter) {
            self.shelter = Bool(shelter == "N" ? "false" : "true")
        }
        
        if let picnic = try container.decodeIfPresent(String.self, forKey: .picnic) {
            self.picnic = Bool(picnic == "N" ? "false" : "true")
        }
        
        self.webcam = try container.decodeIfPresent(String.self, forKey: .webcam)
        self.trig = try container.decodeIfPresent(String.self, forKey: .trig)
        self.hump = try container.decodeIfPresent(String.self, forKey: .hump)
        
        if let wikipedia = try container.decodeIfPresent(String.self, forKey: .wikipedia) {
            if let url = URL(string: wikipedia) {
                self.wikipedia = url
            }
        }
        
        self.maplink = try container.decodeIfPresent(String.self, forKey: .maplink)
        self.mill = try container.decodeIfPresent(String.self, forKey: .mill)
        
        if let url = try container.decodeIfPresent(String.self, forKey: .url) {
            if let url = URL(string: url) {
                self.url = url
            }
        }
        
        self.comment = try container.decodeIfPresent(String.self, forKey: .comment)
        self.arlhs = try container.decodeIfPresent(String.self, forKey: .arlhs)
        self.awardflag = try container.decodeIfPresent(String.self, forKey: .awardflag)
        self.illw = try container.decodeIfPresent(String.self, forKey: .illw)
        self.wac = try container.decodeIfPresent(String.self, forKey: .wac)
        self.district = try container.decodeIfPresent(String.self, forKey: .district)
        self.function = try container.decodeIfPresent(String.self, forKey: .function)
        self.state = try container.decodeIfPresent(String.self, forKey: .state)
        
        if let ruin = try container.decodeIfPresent(String.self, forKey: .ruin) {
            self.ruin = Bool(ruin == "0" ? "false" : "true")
        }
        
        if let type = try container.decodeIfPresent(String.self, forKey: .type) {
            self.type = Int(type)
        }
        
        if let lat2 = try container.decodeIfPresent(String.self, forKey: .lat2) {
            self.lat2 = Double(lat2)
        }
        
        if let lng2 = try container.decodeIfPresent(String.self, forKey: .lng2) {
            self.lng2 = Double(lng2)
        }
    }
}
