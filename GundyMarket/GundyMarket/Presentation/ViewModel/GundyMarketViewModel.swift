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
    
    private let numberFormatter: NumberFormatter
    private let dateFormatter: DateFormatter
    private let imageCacheManager: ImageDataCacheManager
    private let networkManager: NetworkManager
    private var page = 1
    
    //MARK: - Lifecycle
    
    init(
        numberFormatter: NumberFormatter,
        dateFormatter: DateFormatter,
        imageCacheManager: ImageDataCacheManager,
        networkManager: NetworkManager
    ) {
        self.numberFormatter = numberFormatter
        self.dateFormatter = dateFormatter
        self.imageCacheManager = imageCacheManager
        self.networkManager = networkManager
    }
    
    //MARK: - Public
    
    func loadNewList() async {
        page = 1
        await loadMoreList()
    }
    
    func loadMoreList() async {
        let builder = ProductListBuilder(
            pageNumber: page,
            itemsPerPage: 20
        )
        let isNewList = page == 1
        
        page += 1
        let result = await networkManager.request(builder)
        
        switch result {
        case .success(let response):
            let products = response.products.map {
                $0.toDomain(
                    numberFormatter: numberFormatter,
                    dateFormatter: dateFormatter
                )
            }
            
            isNewList ? self.delegate?.setList(with: products) : self.delegate?.appendNewItems(products)
        case .failure(_):
            break
        }
    }
    
    func data(for key: String) async -> Data? {
        return await imageCacheManager.get(for: key)
    }
    
    func string(for date: Date) -> String {
        let timeInterval = Date.now.timeIntervalSince(date)
        
        return Time(timeInterval: timeInterval).string() + " 전"
    }
}
