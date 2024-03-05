//
//  Product.swift
//  GundyMarket
//
//  Created by Gundy on 3/4/24.
//

import Foundation

struct Product: Hashable {
    let id: Int?
    let vendorName: String?
    let name: String
    let description: String
    let thumbnailURL: String
    let currency: Currency
    let price: Int
    let issuedAt: String
    let isEdited: Bool
}
