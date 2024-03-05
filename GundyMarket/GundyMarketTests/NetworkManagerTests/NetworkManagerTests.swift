//
//  NetworkManagerTests.swift
//  GundyMarketTests
//
//  Created by Gundy on 3/2/24.
//

import XCTest
@testable import GundyMarket

final class NetworkManagerTests: XCTestCase {
    private var sut: NetworkManager!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        sut = NetworkManager(session: StubNetworkSession())
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        sut = nil
    }
    
    func testNetworkManager_잘못된_baseURL을_제공하는_Builder를_사용하면_completion에_failure가_전달된다() {
        // given
        let builder = DummyURLFailBuilder()
        var number = 0
        
        // when
        sut.request(builder) { result in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(_):
                number = 1
            }
        }
        
        // then
        XCTAssertEqual(number, 1)
    }
    
    func testNetworkManager_잘못된_path를_제공하는_Builder를_사용하면_completion에_failure가_전달된다() {
        // given
        let builder = DummyPathFailBuilder()
        var number = 0
        
        // when
        sut.request(builder) { result in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(_):
                number = 1
            }
        }
        
        // then
        XCTAssertEqual(number, 1)
    }
    
    func testNetworkManager_정확한_URL을_제공하지만_deserialize에_실패하면_completion에_failure가_전달된다() {
        // given
        let builder = DummyDeserializeFailBuilder()
        var number = 0
        
        // when
        sut.request(builder) { result in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(_):
                number = 1
            }
        }
        
        // then
        XCTAssertEqual(number, 1)
    }
    
    func testNetworkManager_정확한_URL을_제공하는_Builder를_사용하면_completion에_success가_전달된다() {
        // given
        let builder = DummyProductDetailBuilder()
        var number = 0
        
        // when
        sut.request(builder) { result in
            switch result {
            case .success(_):
                number = 1
            case .failure(_):
                XCTFail()
            }
        }
        
        // then
        XCTAssertEqual(number, 1)
    }
    
    func testNetworkManager_ProductDTO를_요청하는_Builder를_사용하면_completion에_success로_전달되는_값의_타입은_ProductDTO다() {
        // given
        let builder = DummyProductDetailBuilder()
        
        // when
        let expectedType = ProductDTO.self
        
        // then
        sut.request(builder) { result in
            switch result {
            case .success(let product):
                XCTAssertEqual(String(describing: type(of: product)), String(describing: expectedType))
            case .failure(_):
                XCTFail()
            }
        }
    }
    
    func testNetworkManager_ProductDTO를_요청하는_Builder를_사용하면_completion에_success로_전달되는_값은_예상과_같다() {
        // given
        let builder = DummyProductDetailBuilder()
        
        // when
        let expectedID = 2456
        let expectedName = "사진 모음집"
        let expectedDescription = "AI로 그린 사진 모음입니다"
        let expectedThumbnailURL = "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/48/20240207/b5b494eac59a11eeaa7e89c63665c7a3_thumb.png"
        let expectedCurrency = Currency.krw
        let expectedPrice = 1000
        let expectedCreatedAt = "2024-02-07T00:00:00"
        let expectedIssuedAt = "2024-02-07T00:00:00"
        
        // then
        sut.request(builder) { result in
            switch result {
            case .success(let product):
                XCTAssertEqual(product.id, expectedID)
                XCTAssertEqual(product.name, expectedName)
                XCTAssertEqual(product.description, expectedDescription)
                XCTAssertEqual(product.thumbnailURL, expectedThumbnailURL)
                XCTAssertEqual(product.currency, expectedCurrency)
                XCTAssertEqual(product.price, expectedPrice)
                XCTAssertEqual(product.createdAt, expectedCreatedAt)
                XCTAssertEqual(product.issuedAt, expectedIssuedAt)
            case .failure(_):
                XCTFail()
            }
        }
    }
    
    func testNetworkManager_ProductDTOList를_요청하는_Builder를_사용하면_completion에_success로_전달되는_값의_타입은_ProductDTOList다() {
        // given
        let builder = DummyProductListBuilder()
        
        // when
        let expectedType = ProductDTOList.self
        
        // then
        sut.request(builder) { result in
            switch result {
            case .success(let product):
                XCTAssertEqual(String(describing: type(of: product)), String(describing: expectedType))
            case .failure(_):
                XCTFail()
            }
        }
    }
}
