import Foundation

@available(macOS 13.0, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public struct CQGMASpots: Decodable, CQGMAApiType {
    public var SOURCE: String
    public var RECORDS: String
    public var TIMESTAMP: Int
    public var RCD: [CQGMASpot]
}
