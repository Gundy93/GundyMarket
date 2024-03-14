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

    func dataTask(with request: URLRequest) async -> Result<Data, Error> {
        do {
            let (data, _) = try await session.data(for: request)
            
            return .success(data)
        } catch {
            return .failure(error)
        }
    }
}
