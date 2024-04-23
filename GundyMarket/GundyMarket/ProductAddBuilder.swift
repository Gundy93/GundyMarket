//
//  ProductAddBuilder.swift
//  GundyMarket
//
//  Created by Gundy on 4/18/24.
//

import Foundation

struct ProductAddBuilder: NetworkBuilderProtocol {
    typealias Response = ProductDTO
    
    // MARK: - Public property
    
    var baseURL: String { "http://openmarket.yagom-academy.kr" }
    var path: String { "api/products" }
    var headers: [String : String] {
        [
            "identifier" : Bundle.main.object(forInfoDictionaryKey: "VendorIdentifier") as! String,
            "Content-Type" : "multipart/form-data; boundary=" + boundary
        ]
    }
    var parameters: [String : Any]
    var httpMethod: String { "POST" }
    var serializer: NetworkSerializable? { MultipartFormDataSerializer(boundary: boundary) }
    var deserializer: NetworkDeserializable = JSONNetworkDeserializer(decoder: .init())
    
    
    // MARK: - Private property
    
    private let boundary: String
    
    // MARK: - Lifecycle
    
    init(
        boundary: String,
        product: Data,
        images: [Data]
    ) {
        self.boundary = boundary
        parameters = [
            "params" : product,
            "images" : images
        ]
    }
}
