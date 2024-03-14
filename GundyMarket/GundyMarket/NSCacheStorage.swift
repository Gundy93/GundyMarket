//
//  NSCacheStorage.swift
//  GundyMarket
//
//  Created by Gundy on 3/14/24.
//

import Foundation

final class NSCacheStorage: CacheStorageProtocol {

    // MARK: - Private property

    private let nsCache: NSCache<NSString, NSData>

    // MARK: - Lifecycle

    init(nsCache: NSCache<NSString, NSData>) {
        self.nsCache = nsCache
    }

    // MARK: - Public

    func load(for key: String) -> Data? {
        guard let data = nsCache.object(forKey: NSString(string: key)) else { return nil }
        
        return data as Data
    }

    func save(_ data: Data, for key: String) {
        let data = NSData(data: data)
        let key = NSString(string: key)
        
        nsCache.setObject(data, forKey: key)
    }
}
