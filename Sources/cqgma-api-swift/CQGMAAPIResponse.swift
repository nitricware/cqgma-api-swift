import Foundation

public protocol CQGMAAPIResponse: Decodable {
    var CHECKLOG: String { get set }
}
