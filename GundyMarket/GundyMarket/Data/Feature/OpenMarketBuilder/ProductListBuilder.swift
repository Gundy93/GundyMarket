//
//  ProductListBuilder.swift
//  GundyMarket
//
//  Created by Gundy on 3/4/24.
//

import Foundation

struct ProductListBuilder: NetworkBuilderProtocol {
    typealias Response = ProductDTOList
    
    // MARK: - Public property
    
    var baseURL: String { "http://openmarket.yagom-academy.kr" }
    var path: String { "/api/products?page_no=\(pageNumber)&items_per_page=\(itemsPerPage)" }
    var deserializer: NetworkDeserializable = JSONNetworkDeserializer(decoder: .init())
    
    // MARK: - Private property
    
    private let pageNumber: Int
    private let itemsPerPage: Int
    
    // MARK: - Lifecycle
    
    init(
        pageNumber: Int,
        itemsPerPage: Int
    ) {
        self.pageNumber = pageNumber
        self.itemsPerPage = itemsPerPage
    }
}
