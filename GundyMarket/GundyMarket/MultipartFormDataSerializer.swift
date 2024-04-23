//
//  MultipartFormDataSerializer.swift
//  GundyMarket
//
//  Created by Gundy on 4/18/24.
//

import Foundation

struct MultipartFormDataSerializer: NetworkSerializable {
    
    // MARK: - Private property
    
    private let lineBreak = "\r\n"
    private let boundary: String
    
    // MARK: - Lifecycle
    
    init(boundary: String) {
        self.boundary = boundary
    }
    
    // MARK: - Public
    
    func serialize(_ parameters: [String: Any]) throws -> Data {
        var body = Data()
        
        if let product = parameters["params"] as? Data {
            body = append(
                product,
                to: body,
                name: "params",
                contentType: "application/json"
            )
        }
        
        if let images = parameters["images"] as? [Data] {
            images.forEach {
                body = append(
                    $0,
                    to: body,
                    name: "images",
                    fileName: "image.jpeg",
                    contentType: "image/jpeg"
                )
            }
        }
        
        body.append(dataFrom(string: "--" + boundary + "--"))
        
        return body
    }
    
    // MARK: - Private
    
    private func append(
        _ data: Data,
        to body: Data,
        name: String,
        fileName: String? = nil,
        contentType: String
    ) -> Data {
        var body = body
        
        [
            dataFrom(string: "--" + boundary + lineBreak),
            fileName != nil ? dataFrom(string: "Content-Disposition:form-data; name=\"\(name)\"; filename=\"\(fileName!)\"" + lineBreak) : dataFrom(string: "Content-Disposition:form-data; name=\"\(name)\"" + lineBreak),
            dataFrom(string: "Content-Type: \(contentType)" + lineBreak),
            dataFrom(string: lineBreak),
            data,
            dataFrom(string: lineBreak)
        ].forEach { body.append($0) }
        
        return body
    }
    
    private func dataFrom(string: String) -> Data {
        guard let data = string.data(using: .utf8) else { return Data() }
        
        return data
    }
}
