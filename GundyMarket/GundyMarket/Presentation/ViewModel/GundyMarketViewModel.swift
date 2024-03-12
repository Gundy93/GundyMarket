//
//  GundyMarketViewModel.swift
//  GundyMarket
//
//  Created by Gundy on 3/12/24.
//

import Foundation

final class GundyMarketViewModel {
    
    //MARK: - Public property
    
    weak var delegate: ProductListViewModelDelegate?
    
    //MARK: - Private property
    
    private let networkManager: NetworkManager
    private var page = 1
    
    //MARK: - Lifecycle
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    //MARK: - Public
    
    func loadNewList() {
        page = 1
        loadMoreList()
    }
    
    func loadMoreList() {
        let builder = ProductListBuilder(
            pageNumber: page,
            itemsPerPage: 20
        )
        let isNewList = page == 1
        
        page += 1
        networkManager.request(builder) { result in
            switch result {
            case .success(let response):
                let products = response.products.map { $0.toDomain() }
                
                isNewList ? self.delegate?.setList(with: products) : self.delegate?.appendNewItems(products)
            case .failure(_):
                break
            }
        }
    }
}
