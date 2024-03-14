//
//  CacheStorageProtocol.swift
//  GundyMarket
//
//  Created by Gundy on 3/14/24.
//

import Foundation

protocol CacheStorageProtocol {
    func load(for key: String) -> Data?
    func save(_ data: Data, for key: String)
}
