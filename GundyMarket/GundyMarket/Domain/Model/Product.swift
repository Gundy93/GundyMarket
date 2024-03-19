//
//  Product.swift
//  GundyMarket
//
//  Created by Gundy on 3/4/24.
//

import Foundation

struct Product: Hashable {
    let id: Int?
    let vendor: User
    let name: String
    let description: String
    let thumbnailURL: String
    let currency: Currency
    let priceText: String
    let issuedAt: Date
    let isEdited: Bool
}
