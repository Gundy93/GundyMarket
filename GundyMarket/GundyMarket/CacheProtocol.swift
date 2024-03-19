//
//  CacheProtocol.swift
//  GundyMarket
//
//  Created by Gundy on 3/14/24.
//

import Foundation

protocol CacheProtocol {
    func get(for key: String) -> Data?
    func store(_ value: Data, for key: String)
}
