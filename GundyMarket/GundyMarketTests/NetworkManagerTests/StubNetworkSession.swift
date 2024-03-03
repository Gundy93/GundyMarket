//
//  StubNetworkSession.swift
//  GundyMarketTests
//
//  Created by Gundy on 3/2/24.
//

import Foundation
@testable import GundyMarket

final class StubNetworkSession: NetworkSessionProtocol {
    func dataTask(
        with request: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void
    ) {
        var fileName = String()
        
        switch request.url?.absoluteString {
        case "http://openmarket.yagom-academy.kr/api/products/2456":
            fileName = "product"
        case "http://openmarket.yagom-academy.kr/api/products?page_no=2&items_per_page=20":
            fileName = "productList"
        default:
            break
        }
        
        guard fileName != String(),
              let filePath = Bundle(for: Self.self).path(forResource: fileName, ofType: "json") else {
            completion(.failure(NetworkError.responseNotFound))
            return
        }
        
        do {
            let data = try Data(contentsOf: URL(filePath: filePath))
            
            completion(.success(data))
        } catch {
            completion(.failure(error))
        }
    }
}
