//
//  SpyCache.swift
//  GundyMarketTests
//
//  Created by Gundy on 3/18/24.
//

import Foundation
@testable import GundyMarket

final class SpyCache: CacheProtocol {
    var cacheStorage: [String : Data]
    var isCalledGetMethod = false
    var isCalledStoreMethod = false
    
    init(cacheStorage: [String : Data]) {
        self.cacheStorage = cacheStorage
    }
    
    func get(for key: String) -> Data? {
        isCalledGetMethod = true
        
        return cacheStorage[key]
    }
    
    func store(_ value: Data, for key: String) {
        isCalledStoreMethod = true
        cacheStorage[key] = value
    }
}
