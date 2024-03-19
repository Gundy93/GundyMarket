//
//  SpyImageSession.swift
//  GundyMarketTests
//
//  Created by Gundy on 3/18/24.
//

import Foundation
@testable import GundyMarket

final class SpyImageSession: NetworkSessionProtocol {
    var isCalledDataTask = false
    
    func dataTask(with request: URLRequest) async -> Result<Data, Error> {
        isCalledDataTask = true
        
        return .success(Data())
    }
}

final class StubImageSession: NetworkSessionProtocol {
    func dataTask(with request: URLRequest) async -> Result<Data, Error> {
        .failure(NetworkError.responseNotFound)
    }
}
