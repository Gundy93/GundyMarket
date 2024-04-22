//
//  ProductDeleteBuilder.swift
//  GundyMarket
//
//  Created by Gundy on 4/22/24.
//

import Foundation

struct ProductDeleteBuilder: NetworkBuilderProtocol {
    typealias Response = String
    
    // MARK: - Public property
    
    var baseURL: String { "http://openmarket.yagom-academy.kr" }
    var path: String
    var httpMethod: String { "DELETE" }
    var deserializer: NetworkDeserializable = JSONNetworkDeserializer(decoder: .init())
    
    // MARK: - Lifecycle
    
    init(uri: String) {
        path = uri
    }
}
