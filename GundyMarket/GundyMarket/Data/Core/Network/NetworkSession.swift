//
//  NetworkSession.swift
//  GundyMarket
//
//  Created by Gundy on 3/4/24.
//

import Foundation

final class NetworkSession: NetworkSessionProtocol {

    // MARK: - Private property

    private let session: URLSession

    // MARK: - Lifecycle

    init(session: URLSession) {
        self.session = session
    }

    // MARK: - Public

    func dataTask(
        with request: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void
    ) {
        let task = session.dataTask(with: request) { (data, _, error) in
            if let error {
                completion(.failure(error))
                return
            }

            guard let data else {
                completion(.failure(NetworkError.responseNotFound))
                return
            }

            completion(.success(data))
        }
        task.resume()
    }
}
