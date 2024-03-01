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

    func request<Builder: NetworkBuilderProtocol>(
        _ builder: Builder,
        completion: @escaping (Result<Builder.Response, Error>) -> Void
    ) {
        do {
            let request = try makeRequest(builder)
            
            session.dataTask(with: request) { result in
                switch result {
                case .success(let data):
                    do {
                        let response: Builder.Response = try builder.deserializer.deserialize(data)
                        
                        completion(.success(response))
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }

    // MARK: - Private

    private func makeRequest<Builder: NetworkBuilderProtocol>(_ builder: Builder) throws -> URLRequest {
        guard let url = URL(string: builder.baseURL + builder.path) else {
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
