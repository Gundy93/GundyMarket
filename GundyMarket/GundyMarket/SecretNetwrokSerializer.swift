//
//  SecretNetwrokSerializer.swift
//  GundyMarket
//
//  Created by Gundy on 4/22/24.
//

import Foundation

struct SecretNetwrokSerializer: NetworkSerializable {
    
    // MARK: - Private property

    private let encoder: JSONEncoder

    // MARK: - Lifecycle

    init(encoder: JSONEncoder) {
        self.encoder = encoder
    }

    // MARK: - Public
    
    func serialize(_ parameters: [String : Any]) throws -> Data {
        guard let secret = parameters["secret"] as? Secret else { throw SerializerError.parameterValueNotFount }
                
        return try encoder.encode<Secret>(secret) 
    }
}
