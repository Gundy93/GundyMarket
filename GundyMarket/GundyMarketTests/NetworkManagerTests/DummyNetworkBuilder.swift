//
//  DummyNetworkBuilder.swift
//  GundyMarketTests
//
//  Created by Gundy on 3/2/24.
//

import Foundation
@testable import GundyMarket

struct DummyProductDetailBuilder: NetworkBuilderProtocol {
    typealias Response = ProductDTO
    
    var baseURL: String { "http://openmarket.yagom-academy.kr" }
    var path: String { "api/products/2456" }
    let deserializer: GundyMarket.NetworkDeserializable = JSONNetworkDeserializer(decoder: .init())
}

struct DummyProductListBuilder: NetworkBuilderProtocol {
    typealias Response = ProductDTOList
    
    var baseURL: String { "http://openmarket.yagom-academy.kr" }
    var path: String { "api/products" }
    var queryItems: [String : String] {
        [
            "page_no" : "2",
            "items_per_page" : "20"
        ]
    }
    let deserializer: GundyMarket.NetworkDeserializable = JSONNetworkDeserializer(decoder: .init())
}

struct DummyDeserializeFailBuilder: NetworkBuilderProtocol {
    typealias Response = ProductDTO
    
    var baseURL: String { "http://openmarket.yagom-academy.kr" }
    var path: String { "/api/products" }
    var queryItems: [String : String] {
        [
            "page_no" : "2",
            "items_per_page" : "20"
        ]
    }
    let deserializer: GundyMarket.NetworkDeserializable = JSONNetworkDeserializer(decoder: .init())
}

struct DummyPathFailBuilder: NetworkBuilderProtocol {
    typealias Response = ProductDTO
    
    var baseURL: String { "http://openmarket.yagom-academy.kr" }
    var path: String { "" }
    let deserializer: GundyMarket.NetworkDeserializable = JSONNetworkDeserializer(decoder: .init())
}

struct DummyURLFailBuilder: NetworkBuilderProtocol {
    typealias Response = ProductDTO
    
    var baseURL: String { "" }
    var path: String { "" }
    let deserializer: GundyMarket.NetworkDeserializable = JSONNetworkDeserializer(decoder: .init())
}
