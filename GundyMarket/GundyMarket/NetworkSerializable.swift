//
//  NetworkSerializable.swift
//  GundyMarket
//
//  Created by Gundy on 3/2/24.
//

import Foundation

protocol NetworkSerializable {
    func serialize(_ parameters: [String: Any]) throws -> Data
}
