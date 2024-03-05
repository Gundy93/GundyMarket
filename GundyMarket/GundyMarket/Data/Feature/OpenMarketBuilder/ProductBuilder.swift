//
//  ProductBuilder.swift
//  GundyMarket
//
//  Created by Gundy on 3/4/24.
//

import Foundation

struct ProductBuilder: NetworkBuilderProtocol {
    typealias Response = ProductDTO
    
    // MARK: - Public property
    
    var baseURL: String { "http://openmarket.yagom-academy.kr" }
    var path: String { "/api/products/\(id)" }
    var deserializer: NetworkDeserializable = JSONNetworkDeserializer(decoder: .init())
    
    // MARK: - Private property
    
    private let id: Int
    
    // MARK: - Lifecycle
    
    init(id: Int) {
        self.id = id
    }
}
