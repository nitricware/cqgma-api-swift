// CQGMA API Swift implementation
// MIT License
// Created by Kurt Frey aka NitricWare
// on 2024-08-21
//
// Pauli was here.

import Foundation

// TOOD: Handle empty responses.

@available(macOS 13.0, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public class CQGMA: ObservableObject {
    public var apiURL:URL? = URL(string: "https://www.cqgma.org/api/")
    
    public var username: String?
    public var password: String?
    
    @Published var spots: CQGMASpots?
    
    /// Returns an array of CQGMA spots
    /// - Parameter type: CQGMASpotsType
    /// - Parameter count: CQGMASpotsCount
    /// - Returns: CQGMASpots
    /// - throws: DecodingError
    public func get(type: CQGMASpotsType, count: CQGMASpotsCount = .Spots10) async throws -> CQGMASpots {
        
        guard var url = apiURL else {
            throw CQGMAErrors.URLError
        }
        
        url.append(path: CQGMAApiType.GetSpots.rawValue)
        
        if type == .GMA {
            url.append(path: count.rawValue)
        }
        
        if type == .WWFF {
            url.append(path: CQGMAApiType.GetWWFF.rawValue)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(CQGMASpots.self, from: data)
    }
    
    /// Fetches a CQGMA reference
    /// - Parameter ref: Reference string
    /// - Returns: CQGMARef
    public func get(ref: String) async throws -> CQGMARef? {
        guard var url = apiURL else {
            throw CQGMAErrors.URLError
        }
        
        url.append(path: CQGMAApiType.GetRef.rawValue)
        
        url.append(queryItems: [URLQueryItem(name: ref.replacingOccurrences(of: "\\/", with: "/"), value: "")])
        
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(CQGMARef.self, from: data)
    }
    
    /// Get the raw data of a REF API request
    /// - Parameter ref: Reference string
    public func getRaw(ref: String) async throws -> Data{
        return try await getRaw(
            path: [CQGMAApiType.GetRef.rawValue],
            queryItems: [URLQueryItem(name: ref.replacingOccurrences(of: "\\/", with: "/"), value: "")]
        )
    }
    
    /// Get the raw data of GMA spots API request
    /// - Parameter spots: CQGMASpotsCount
    public func getRaw(spots: CQGMASpotsCount) async throws -> Data {
        return try await getRaw(path: [CQGMAApiType.GetSpots.rawValue, spots.rawValue])
    }
    
    /// Get the raw data of a GMA spots (GMA or WWFF) API request
    /// - Parameter type: CQGMASpotsType
    /// - Parameter count: CQGMASpotsCount
    public func getRaw(type: CQGMASpotsType, count:CQGMASpotsCount = .Spots10) async throws -> Data {
        switch type {
        case .GMA:
            return try await getRaw(spots: count)
        case .WWFF:
            return try await getRaw(path: [CQGMAApiType.GetSpots.rawValue, CQGMAApiType.GetWWFF.rawValue])
        }
    }
    
    /// Get the raw data of any CQGMA API request
    /// - Parameter path: CQGMA API path
    /// - Parameter queryItems: CQGMA API query items
    private func getRaw(path: [String], queryItems: [URLQueryItem]? = nil) async throws -> Data {
        guard var url = apiURL else {
            throw CQGMAErrors.URLError
        }
        
        path.forEach({ url.append(path: $0) })
        
        if let q = queryItems {
            url.append(queryItems: q)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
    
    /// Get the parsed data of a CQGMA spots API request
    /// This function will make a deep call to the api and
    /// automatically fetch reference objects too.
    public func getDeep(type: CQGMASpotsType, count: CQGMASpotsCount = .Spots10) async throws -> CQGMASpots? {
        var rawSpots: Data
        
        switch type {
        case .GMA:
            rawSpots =  try await getRaw(spots: count)
        case .WWFF:
            rawSpots =  try await getRaw(path: [CQGMAApiType.GetSpots.rawValue, CQGMAApiType.GetWWFF.rawValue])
        }
        
        // "REF": "TF\/VF-085",
        // ("REF": "([A-Z0-9\\/-]+)",)
        let regex = #/("REF": "([A-Z0-9\\/-]+)",)/#
        
        if var dataString = String(data: rawSpots, encoding: .utf8) {
            let matches = dataString.matches(of: regex)
            for match in matches {
                let originalMatch = match.output.2
                let cleanMatch = originalMatch.replacingOccurrences(of: "\\/", with: "/")
                let refObject = try await getRaw(ref: cleanMatch)
                let refString = String(data: refObject, encoding: .utf8)!
                
                dataString = dataString.replacingOccurrences(
                    of: "\"REF\": \"\(originalMatch)\"",
                    with: "\"REF\": \"\(cleanMatch)\",\"REFOBJ\": \(refString)"
                )
            }
            
            if let modifiedData = dataString.data(using: .utf8) {
                return try JSONDecoder().decode(CQGMASpots.self, from: modifiedData)
            }
        }
        
        return nil
    }
    
    /// Loads the requested number of spots (GMA or WWFF)
    /// into the published property `spots`.
    /// - Parameter type: GMA or WWFF
    /// - Parameter count: number of GMA spots
    /// - Throws
    public func loadDeep(type: CQGMASpotsType, count: CQGMASpotsCount = .Spots10) async throws {
        self.spots = try await getDeep(type: type, count: count)
    }
    
    public func load(type: CQGMASpotsType, count: CQGMASpotsCount = .Spots10) async throws {
        self.spots = try await get(type: type, count: count)
    }
    
    public func send<T: CQGMAAPIResponse>(type: CQGMAApiType, payload: CQGMAAPIPayload) async throws -> T {
        guard var url = apiURL else {
            throw CQGMAErrors.URLError
        }
        
        url.append(path: type.rawValue)
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PUT"
        let encodedPayload = try JSONEncoder().encode(payload)
        request.httpBody = encodedPayload
        
        debugPrint("sending payload (\(payload)) as encoded payload (\(String(data: encodedPayload, encoding: .utf8) ?? "Encoding Error")) to \(url.absoluteString)")
        
        let (data, _) = try await URLSession.shared.upload(for: request, from: encodedPayload)
        /**
         CQGMA API response returns corrupt JSON when
         deleting a QSO. It prepends some arbitrary text
         describing the affected data sets.
         `CQGMAHelper.removeArbitraryText(from: data)`
         removes that text and returns plain JSON. This
         approach is somewhat error prone, of ocurse.
         */
        return try JSONDecoder().decode(T.self, from: CQGMAHelper.removeArbitraryText(from: data) ?? data)
    }
    
    public func send(spotCapsule: CQGMASendSpotCapsule) async throws -> CQGMASendSpotResponse {
        return try await send<CQGMASendSpotResponse>(type: .SendSpot, payload: spotCapsule)
    }
    
    public func send(spots: [CQGMASendSpot]) async throws -> CQGMASendSpotResponse {
        guard let username = username, let password = password else {
            throw CQGMAErrors.credentialError
        }
        
        let spotCapsule = CQGMASendSpotCapsule(
            USER: username,
            PSWD: password,
            DUMP: 0,
            SPOT: spots
        )
        return try await send(spotCapsule: spotCapsule)
    }
    
    public func send(log: CQGMALog) async throws -> CQGMASendLogResponse {
        return try await send<CQGMASendLogResponse>(type: .SendLog, payload: log)
    }
    
    public func send(qsos: [CQGMAQSO]) async throws -> CQGMASendLogResponse {
        guard let username = username, let password = password else {
            throw CQGMAErrors.credentialError
        }
        
        let log = CQGMALog(USER: username, PSWD: password, DUMP: 0, LIVE: 0, LOGC: 0, QSO: qsos)
        return try await send(log: log)
    }
}
