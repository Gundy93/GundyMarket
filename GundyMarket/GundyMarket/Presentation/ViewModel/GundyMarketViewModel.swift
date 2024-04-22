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
    
    func addProduct(
        name: String,
        description: String,
        price: String,
        images: [Data]
    ) async throws {
        guard let price = numberFormatter.number(from: price) as? Int else { throw ProductAddError.invalidPrice }
        
        let product = ProductDTOForUpload(
            name: name,
            description: description,
            price: price,
            secret: Bundle.main.object(forInfoDictionaryKey: "UserPassword") as! String
        )
        
        guard let productData = try? JSONEncoder().encode(product) else { throw ProductAddError.canNotEncode }
        
        let builder = ProductAddBuilder(
            boundary: "----boundary",
            product: productData,
            images: images.reduce(Data()) {
                var data = $0
                
                data.append($1)
                
                return data
            }
        )
        
        let result = await networkManager.request(builder)
        
        switch result {
        case .success(_):
            return
        case .failure(let error):
            throw error
        }
    }
    
    func deleteProduct() async throws {
        let uri = try await searchDeleteURI()
        let builder = ProductDeleteBuilder(uri: uri)
        let result = await networkManager.request(builder)
        
        switch result {
        case .success(_):
            return
        case .failure(let error):
            throw error
        }
    }
    
    // MARK: - Private
    
    private func searchDeleteURI() async throws -> String {
        guard let id = product?.id else { throw ProductDeleteError.invaildProduct }
        
        let builder = ProductDeleteURIBuilder(id: id)
        let result = await networkManager.request(builder)
        
        switch result {
        case .success(let uri):
            return uri
        case .failure(let error):
            throw error
        }
    }
    
    // MARK: - Nested type
    
    enum ProductAddError: Error {
        case invalidPrice
        case canNotEncode
    }
    
    enum ProductDeleteError: Error {
        case invaildProduct
    }
}
