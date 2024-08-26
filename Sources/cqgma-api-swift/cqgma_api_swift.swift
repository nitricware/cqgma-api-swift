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
    public var spotsUrl:URL? = URL(string: "https://www.cqgma.org/api/spots/")
    public var refUrl:URL? = URL(string: "https://www.cqgma.org/api/ref/")
    public var apiURL:URL? = URL(string: "https://www.cqgma.org/api/")
    
    public var username: String?
    public var password: String?
    
    @Published var spots: CQGMASpots?
    
    /// Returns an array of CQGMA spots
    /// - Parameter type: CQGMASpotsType
    /// - Parameter count: CQGMASpotsCount
    /// - Returns: CQGMASpots
    /// - throws: DecodingError
    public func get(type: CQGMASpotsType, count: CQGMASpotsCount = .Spots10) async throws {
        
        guard var url = spotsUrl else {
            throw CQGMAErrors.SpotsUrlError
        }
        
        if type == .GMA {
            url.append(path: count.rawValue)
        }
        
        if type == .WWFF {
            url.append(path: "wwff")
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        self.spots = try JSONDecoder().decode(CQGMASpots.self, from: data)
    }
    
    /// Fetches a CQGMA reference
    /// - Parameter ref: Reference string
    /// - Returns: CQGMARef
    public func get(ref: String) async throws -> CQGMARef {
        // TODO: use <T>
        guard var url = refUrl else {
            throw CQGMAErrors.RefUrlError
        }
        
        url.append(queryItems: [URLQueryItem(name: ref.replacingOccurrences(of: "\\/", with: "/"), value: "")])
        
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(CQGMARef.self, from: data)
    }
    
    /// Get the raw data of a REF API request
    /// - Parameter ref: Reference string
    public func getRaw(ref: String) async throws -> Data{
        return try await getRaw(
            path: ["ref"],
            queryItems: [URLQueryItem(name: ref.replacingOccurrences(of: "\\/", with: "/"), value: "")]
        )
    }
    
    /// Get the raw data of GMA spots API request
    /// - Parameter spots: CQGMASpotsCount
    public func getRaw(spots: CQGMASpotsCount) async throws -> Data {
        return try await getRaw(path: ["spots", spots.rawValue])
    }
    
    /// Get the raw data of a GMA spots (GMA or WWFF) API request
    /// - Parameter type: CQGMASpotsType
    /// - Parameter count: CQGMASpotsCount
    public func getRaw(type: CQGMASpotsType, count:CQGMASpotsCount = .Spots10) async throws -> Data {
        switch type {
        case .GMA:
            return try await getRaw(spots: count)
        case .WWFF:
            return try await getRaw(path: ["spots", "wwff"])
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
            rawSpots =  try await getRaw(path: ["spots", "wwff"])
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
}
