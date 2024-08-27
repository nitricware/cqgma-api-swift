import Foundation

public struct CQGMASendSpotCapsule: CQGMAAPIPayload {
    let USER: String
    let PSWD: String
    let DUMP: Int
    let SPOT: [CQGMASendSpot]
}
