//
//  StringNetworkDeserializer.swift
//  GundyMarket
//
//  Created by Gundy on 4/23/24.
//

import Foundation

struct StringNetworkDeserializer: NetworkDeserializable {
    
    // MARK: - Public

    func deserialize<T: Decodable>(_ data: Data) throws -> T {
        guard let result = String(data: data, encoding: .utf8) as? T else { throw NetworkError.invalidResponse }
        
        return result
    }
}
