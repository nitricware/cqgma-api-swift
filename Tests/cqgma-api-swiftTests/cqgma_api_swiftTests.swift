import XCTest
@testable import cqgma_api_swift

final class cqgma_api_swiftTests: XCTestCase {
    func testGet10Spots() async {
        do {
            debugPrint(try await CQGMA().get(type: .GMA, count: .Spots10))
        } catch {
            debugPrint("[ERROR] in testGet1ßSpots: \(error)")
        }
    }
    
    func testGet25Spots() async {
        do {
            debugPrint(try await CQGMA().get(type: .GMA, count: .Spots25))
        } catch {
            debugPrint("[ERROR] in testGet25Spots: \(error)")
        }
    }
    
    func testGetWWFFSpots() async {
        do {
            debugPrint(try await CQGMA().get(type: .WWFF))
        } catch {
            debugPrint("[ERROR] in testGetWWFFSpots: \(error)")
        }
    }
    
    func testGetRef() async {
        do {
            debugPrint(try await CQGMA().get(ref: "OE0/NO-1139"))
        } catch {
            debugPrint("[ERROR] in testGetRef: \(error)")
        }
        
    }
    
    func testDeep() async {
        do {
            debugPrint(try await CQGMA().getDeep(type: .GMA))
        } catch {
            debugPrint("[ERROR] in testDeep: \(error)")
        }
    }
    
    func testEmptyRefRespons() async {
        do {
            let result = try await CQGMA().get(ref: "OE0/NO-9999")
            XCTAssertThrowsError(result)
        } catch {
            debugPrint("[ERROR] in testEmptyRefRespons: \(error)")
        }
    }
    
    func testSelfSpot() async {
        let spot = CQGMASendSpot(
            MYCALL: "DR0ABC",
            ACTIVATOR: "DR0ABC",
            REF: "OE0/NO-1139",
            KHZ: "14285",
            MODE: "FM",
            REMARKS: "CQGMA SWIFT API TEST"
        )
        
        let cqgma = CQGMA()
        
        cqgma.username = "DR0ABC"
        cqgma.password = "gma"
        
        do {
            let result = try await cqgma.send(spots: [spot])
            debugPrint(result)
        } catch {
            debugPrint("[ERROR] in testSelfSpot: \(error)")
        }
    }
    
    func testSendLog() async {
        let qsoA = CQGMAQSO(
            activation: UUID(),         // Could be omitted
            DATETIME: Date(),           // Could be omitted
            MYCALL: "DR0ABC",
            MYLOC: "JN78UG",
            MAINREF: "OE0/NO-1139",
            WKDCALL: "OE3FKG",
            MHZ: 145.5,
            MODE: "FM",
            RSTS: "59",
            RSTR: "59",
            ACTION: .Add                // Could be omitted
        )
        
        let qsoC = CQGMAQSO(
            chase: UUID(),
            DATETIME: Date(),
            MYCALL: "DR0ABC",
            MYLOC: "JN78UG",
            WKDCALL: "OE3FKG",
            MHZ: 145.5,
            MODE: "FM",
            RSTS: "59",
            RSTR: "59",
            WKDREF: "OE0/NO-1139"
        )
        
        let log = CQGMALog(USER: "DR0ABC", PSWD: "gma", DUMP: 0, LIVE: 0, LOGC: 0, QSO: [qsoA, qsoC])
        
        let cqgma = CQGMA()
        
        cqgma.username = "DR0ABC"
        cqgma.password = "gma"
        
        do {
            let result = try await cqgma.send(log: log)
            debugPrint(result)
        } catch {
            debugPrint("[ERROR] in textSendLog: \(error)")
        }
    }
    
    func testLogIUD() async {
        let cqgma = CQGMA()
        
        cqgma.username = "DR0ABC"
        cqgma.password = "gma"
        
        let qsoUUID = UUID()
        
        let qsoA = CQGMAQSO(
            activation: qsoUUID,         // Could be omitted
            DATETIME: Date(),           // Could be omitted
            MYCALL: "DR0ABC",
            MYLOC: "JN78UG",
            MAINREF: "OE0/NO-1139",
            WKDCALL: "OE3FKG",
            MHZ: 145.5,
            MODE: "FM",
            RSTS: "59",
            RSTR: "59",
            ACTION: .Add                // Could be omitted
        )
        
        do {
            let result = try await cqgma.send(qsos: [qsoA])
            debugPrint(result)
        } catch {
            debugPrint("[ERROR] in textSendLog: \(error)")
        }
        
        // insert breakpoint and check online log at https://cqgma.org
        
        let qsoU = CQGMAQSO(
            activation: qsoUUID,         // Could be omitted
            DATETIME: Date(),           // Could be omitted
            MYCALL: "DR0ABC",
            MYLOC: "JN47UM",
            MAINREF: "OE0/ST-1236",
            WKDCALL: "OE3FKG",
            MHZ: 145.5,
            MODE: "FM",
            RSTS: "59",
            RSTR: "59",
            ACTION: .Update                // Could be omitted
        )
        
        do {
            let result = try await cqgma.send(qsos: [qsoU])
            debugPrint(result)
        } catch {
            debugPrint("[ERROR] in textSendLog: \(error)")
        }
        
        // insert breakpoint and check online log at https://cqgma.org
        
        let qsoD = CQGMAQSO(
            delete: qsoUUID
        )
        
        do {
            let result = try await cqgma.send(qsos: [qsoD])
            debugPrint(result)
        } catch {
            debugPrint("[ERROR] in textSendLog: \(error)")
        }
    }
}
