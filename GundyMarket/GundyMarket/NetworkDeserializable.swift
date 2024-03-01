//
//  NetworkDeserializable.swift
//  GundyMarket
//
//  Created by Gundy on 3/2/24.
//

import Foundation

protocol NetworkDeserializable {
    func deserialize<T: Decodable>(_ data: Data) throws -> T
}
