import XCTest
@testable import cqgma_api_swift

final class cqgma_api_swiftTests: XCTestCase {
    func testGet10Spots() async throws {
        let cqgma = CQGMA()
        try await cqgma.get(type: .GMA, count: .Spots10)
        print(cqgma.spots)
    }
    
    func testGet25Spots() async throws {
        let cqgma = CQGMA()
        try await cqgma.get(type: .GMA, count: .Spots25)
        print(cqgma.spots)
    }
    
    func testGetWWFFSpots() async throws {
        let cqgma = CQGMA()
        try await cqgma.get(type: .WWFF)
        print(cqgma.spots)
    }
    
    func testGetRef() async throws {
        print(try await CQGMA().get(ref: "OE0/NO-1139"))
    }
    
    func testDeep() async throws {
        print(try await CQGMA().getDeep(type: .GMA))
    }
}
