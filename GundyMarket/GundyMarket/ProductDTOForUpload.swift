//
//  ProductDTOForUpload.swift
//  GundyMarket
//
//  Created by Gundy on 4/18/24.
//

import Foundation

struct ProductDTOForUpload: Encodable {
    let name: String
    let description: String
    let price: Int
    let currency = Currency.krw
    let secret: String
    
    enum CodingKeys: String, CodingKey {
        case name, description, price, currency, secret
    }
}
