//
//  NetworkManager.swift
//  GundyMarket
//
//  Created by Gundy on 3/2/24.
//

import Foundation

final class NetworkManager {

    // MARK: - Private property

    private let session: NetworkSessionProtocol

    // MARK: - Lifecycle

    init(session: NetworkSessionProtocol) {
        self.session = session
    }

    // MARK: - Public

    func request<Builder: NetworkBuilderProtocol>(_ builder: Builder) async -> Result<Builder.Response, Error> {
        do {
            let request = try makeRequest(builder)
            let result = await session.dataTask(with: request)
            
            switch result {
            case .success(let data):
                let response: Builder.Response = try builder.deserializer.deserialize(data)
                
                return .success(response)
            case .failure(let error):
                return .failure(error)
            }
        } catch {
            return .failure(error)
        }
    }

    // MARK: - Private

    private func makeRequest<Builder: NetworkBuilderProtocol>(_ builder: Builder) throws -> URLRequest {
        var urlString = builder.baseURL + "/" + builder.path
        
        if builder.queryItems.isEmpty == false {
            urlString += "?" + builder.queryItems.map { $0.key + "=" + $0.value }.joined(separator: "&")
        }
        
        guard let url = URL(string: urlString) else {
            throw NetworkError.urlNotFound
        }
        
        var request = URLRequest(url: url)
        
        request.allHTTPHeaderFields = builder.headers
        request.httpMethod = builder.httpMethod
        
        if let serializer = builder.serializer {
            request.httpBody = try serializer.serialize(builder.parameters)
        }
        
        return request
    }
}
