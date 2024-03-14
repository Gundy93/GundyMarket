//
//  NetworkSessionProtocol.swift
//  GundyMarket
//
//  Created by Gundy on 3/2/24.
//

import Foundation

protocol NetworkSessionProtocol {
    func dataTask(with request: URLRequest) async -> Result<Data, Error>
}
