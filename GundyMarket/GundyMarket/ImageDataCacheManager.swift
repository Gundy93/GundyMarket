//
//  ImageDataCacheManager.swift
//  GundyMarket
//
//  Created by Gundy on 3/14/24.
//

import Foundation

final class ImageDataCacheManager {
    
    // MARK: - Private property
    
    private let memoryCache: CacheProtocol?
    private let diskCache: CacheProtocol?
    private let session: NetworkSessionProtocol
    
    // MARK: - Lifecycle
    
    init(
        memoryCache: CacheProtocol? = nil,
        diskCache: CacheProtocol? = nil,
        session: NetworkSessionProtocol
    ) {
        self.memoryCache = memoryCache
        self.diskCache = diskCache
        self.session = session
    }
    
    // MARK: - Public
    
    func get(for key: String) async -> Data? {
        if let memoryCache,
           let data = memoryCache.get(for: key) {
            return data
        } else if let diskCache,
                  let data = diskCache.get(for: key) {
            memoryCache?.store(data, for: key)
            
            return data
        }
        
        guard let url = URL(string: key) else { return nil }
        
        switch await session.dataTask(with: URLRequest(url: url)) {
        case .success(let data):
            memoryCache?.store(data, for: key)
            diskCache?.store(data, for: key)
            
            return data
        case .failure(_):
            return nil
        }
    }
}
