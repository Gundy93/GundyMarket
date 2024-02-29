//
//  ProductDTOList.swift
//  GundyMarket
//
//  Created by Gundy on 2/29/24.
//

import Foundation

struct ProductDTOList: Decodable {
    let products: [ProductDTO]
    
    enum CodingKeys: String, CodingKey {
        case products = "pages"
    }
}
