//
//  HealthCheckerBuilder.swift
//  GundyMarket
//
//  Created by Gundy on 3/4/24.
//

import Foundation

struct HealthCheckerBuilder: NetworkBuilderProtocol {
    typealias Response = String
    
    // MARK: - Public property
    
    var baseURL: String { "http://openmarket.yagom-academy.kr" }
    var path: String { "healthChecker" }
    var deserializer: NetworkDeserializable = JSONNetworkDeserializer(decoder: .init())
}
