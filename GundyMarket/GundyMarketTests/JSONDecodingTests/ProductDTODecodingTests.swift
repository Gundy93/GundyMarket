//
//  ProductDTODecodingTests.swift
//  GundyMarketTests
//
//  Created by Gundy on 3/2/24.
//

import XCTest
@testable import GundyMarket

final class ProductDTODecodingTests: XCTestCase {
    private var sut: Data!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        guard let filePath = Bundle(for: Self.self).path(forResource: "product", ofType: "json") else { return }
        
        let url = URL(filePath: filePath)
        
        sut = try Data(contentsOf: url)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        sut = nil
    }

    func testProductDTODecoding_주어진_데이터의_형식과_맞지_않는_타입을_decode하면_에러가_발생한다() {
        // given
        let decoder = JSONDecoder()
        
        // when
        let decodingType = String.self
        
        // then
        XCTAssertThrowsError(try decoder.decode(decodingType, from: sut))
    }
    
    func testProductDTODecoding_ProductDTO_타입으로_decode를_수행하면_에러가_발생하지_않는다() {
        // given
        let decoder = JSONDecoder()
        
        // when
        let decodingType = ProductDTO.self
        
        // then
        XCTAssertNoThrow(try decoder.decode(decodingType, from: sut))
    }
    
    func testProductDTODecoding_decode를_수행한_결과가_예상과_같다() throws {
        // given
        let decoder = JSONDecoder()
        
        // when
        let product = try decoder.decode(ProductDTO.self, from: sut)
        
        // then
        XCTAssertEqual(product.id, 2456)
        XCTAssertEqual(product.name, "사진 모음집")
        XCTAssertEqual(product.description, "AI로 그린 사진 모음입니다")
        XCTAssertEqual(product.thumbnailURL, "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/48/20240207/b5b494eac59a11eeaa7e89c63665c7a3_thumb.png")
        XCTAssertEqual(product.currency, .krw)
        XCTAssertEqual(product.price, 1000)
        XCTAssertEqual(product.createdAt, "2024-02-07T00:00:00")
        XCTAssertEqual(product.issuedAt, "2024-02-07T00:00:00")
    }
    
    func testProductDTODecoding_상세_조회의_Response를_decode한_결과의_ProductDTO는_images와_vendor가_nil이아니다() throws {
        // given
        let decoder = JSONDecoder()
        
        // when
        let product = try decoder.decode(ProductDTO.self, from: sut)
        
        // then
        XCTAssertNotNil(product.images)
    }
}
