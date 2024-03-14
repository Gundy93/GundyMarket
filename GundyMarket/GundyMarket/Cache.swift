//
//  Cache.swift
//  GundyMarket
//
//  Created by Gundy on 3/14/24.
//

import Foundation

final class Cache {

    // MARK: - Private property

    private let storage: CacheStorageProtocol

    // MARK: - Lifecycle

    init(storage: CacheStorageProtocol) {
        self.storage = storage
    }

    // MARK: - Public

    func get(for key: String) -> Data? {
        return storage.load(for: "cache_\(key)")
    }

    func store(_ value: Data, for key: String) {
        storage.save(value, for: "cache_\(key)")
    }
}
