//
//  ProductDTO.swift
//  GundyMarket
//
//  Created by Gundy on 2/29/24.
//

import Foundation

struct ProductDTO: Decodable {
    let id: Int
    let vendorName: String?
    let name: String
    let description: String
    let thumbnailURL: String
    let currency: Currency
    let price: Int
    let createdAt: String
    let issuedAt: String
    let images: [ProductImage]?
    let vendor: Vendor?
    
    enum CodingKeys: String, CodingKey {
        case id, vendorName, name, description, currency, images
        case thumbnailURL = "thumbnail"
        case price = "bargain_price"
        case createdAt = "created_at"
        case issuedAt = "issued_at"
        case vendor = "vendors"
    }
}

extension ProductDTO {
    func toDomain() -> Product {
        Product(
            id: id,
            vendorName: vendorName ?? vendor?.name,
            name: name,
            description: description,
            thumbnailURL: thumbnailURL,
            currency: currency,
            price: price,
            issuedAt: issuedAt,
            isEdited: createdAt != issuedAt
        )
    }
}