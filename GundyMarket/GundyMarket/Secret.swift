//
//  Secret.swift
//  GundyMarket
//
//  Created by Gundy on 4/22/24.
//

import Foundation

struct Secret: Encodable {
    let password: String
    
    enum CodingKeys: String, CodingKey {
        case password = "secret"
    }
}
