//
//  NetworkBuilderProtocol.swift
//  GundyMarket
//
//  Created by Gundy on 3/2/24.
//

import Foundation

protocol NetworkBuilderProtocol {
    associatedtype Response: Decodable

    var baseURL: String { get }
    var path: String { get }
    var queryItems: [String : String] { get }
    var headers: [String : String] { get }
    var parameters: [String : Any] { get }
    var httpMethod: String { get }
    var serializer: NetworkSerializable? { get }
    var deserializer: NetworkDeserializable { get }
}

extension NetworkBuilderProtocol {
    var queryItems: [String : String] { [:] }
    var headers: [String : String] { [:] }
    var parameters: [String : Any] { [:] }
    var httpMethod: String { "GET" }
    var serializer: NetworkSerializable? { nil }
}
