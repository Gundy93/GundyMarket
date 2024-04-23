//
//  ProductDeleteURIBuilder.swift
//  GundyMarket
//
//  Created by Gundy on 4/22/24.
//

import Foundation

struct ProductDeleteURIBuilder: NetworkBuilderProtocol {
    typealias Response = String
    
    // MARK: - Public property
    
    var baseURL: String { "http://openmarket.yagom-academy.kr" }
    var path: String { "api/products/\(id)/archived" }
    var headers: [String : String] {
        [
            "identifier" : Bundle.main.object(forInfoDictionaryKey: "VendorIdentifier") as! String,
            "Content-Type" : "application/json"
        ]
    }
    var parameters: [String : Any] { ["secret" : Secret(password: Bundle.main.object(forInfoDictionaryKey: "UserPassword") as! String)] }
    var httpMethod: String { "POST" }
    var serializer: NetworkSerializable? = SecretNetwrokSerializer(encoder: .init())
    var deserializer: NetworkDeserializable = StringNetworkDeserializer()
    
    
    // MARK: - Private property
    
    private let id: Int
    
    // MARK: - Lifecycle
    
    init(id: Int) {
        self.id = id
    }
}
