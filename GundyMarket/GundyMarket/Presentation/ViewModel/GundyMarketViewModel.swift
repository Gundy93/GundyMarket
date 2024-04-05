//
//  GundyMarketViewModel.swift
//  GundyMarket
//
//  Created by Gundy on 3/12/24.
//

import Foundation

@MainActor
final class GundyMarketViewModel {
    
    //MARK: - Public property
    
    weak var listDelegate: ProductListViewModelDelegate?
    weak var detailDelegate: ProductDetailViewModelDelegate?
    private(set) var product: Product? {
        didSet {
            detailDelegate?.setProduct()
        }
    }
    private(set) var imageDatas = [Data]() {
        didSet {
            detailDelegate?.setImageDatas()
        }
    }
    
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
            
            isNewList ? self.listDelegate?.setList(with: products) : self.listDelegate?.appendNewItems(products)
        case .failure(let error):
            print(error)
        }
    }
    
    func data(for key: String) async -> Data? {
        return await imageCacheManager.get(for: key)
    }
    
    func string(for date: Date) -> String {
        let timeInterval = Date.now.timeIntervalSince(date)
        
        return Time(timeInterval: timeInterval).string() + " 전"
    }
    
    func setProduct(_ id: Int) async {
        let builder = ProductBuilder(id: id)
        let result = await networkManager.request(builder)
        
        switch result {
        case .success(let response):
            product = response.toDomain(
                numberFormatter: numberFormatter,
                dateFormatter: dateFormatter
            )
            imageDatas = Array(
                repeating: Data(),
                count: response.images?.count ?? 1
            )
            response.images?.enumerated().forEach { (index, image) in
                Task {
                    imageDatas[index] = await self.imageCacheManager.get(for: image.url) ?? Data()
                }
            }
        case .failure(let error):
            print(error)
        }
    }
    
    func reset() {
        product = nil
        imageDatas = []
    }
}
