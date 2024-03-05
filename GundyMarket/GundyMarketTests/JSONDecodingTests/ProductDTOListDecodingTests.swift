//
//  ProductDTOListDecodingTests.swift
//  NetworkTests
//
//  Created by Gundy on 3/2/24.
//

import XCTest
@testable import GundyMarket

final class ProductDTOListDecodingTests: XCTestCase {
    private var sut: Data!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        guard let filePath = Bundle(for: Self.self).path(forResource: "productList", ofType: "json") else { return }
        
        let url = URL(filePath: filePath)
        
        sut = try Data(contentsOf: url)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        sut = nil
    }
    
    func testProductDTOListDecoding_주어진_데이터의_형식과_맞지_않는_타입을_decode하면_에러가_발생한다() {
        // given
        let decoder = JSONDecoder()
        
        // when
        let decodingType = String.self
        
        // then
        XCTAssertThrowsError(try decoder.decode(decodingType, from: sut))
    }
    
    func testProductDTOListDecoding_ProductDTOList_타입으로_decode를_수행하면_에러가_발생하지_않는다() {
        // given
        let decoder = JSONDecoder()
        
        // when
        let decodingType = ProductDTOList.self
        
        // then
        XCTAssertNoThrow(try decoder.decode(decodingType, from: sut))
    }
    
    func testProductDTOListDecoding_decode를_수행한_결과의_요소수가_예상과_같다() throws {
        // given
        let decoder = JSONDecoder()
        let expectedCount = 20
        
        // when
        let decodedList = try decoder.decode(ProductDTOList.self, from: sut)
        
        // then
        XCTAssertEqual(decodedList.products.count, expectedCount)
    }
    
    func testProductDTOListDecoding_decode를_수행한_결과의_ProductDTO는_images와_vendor가_nil이다() throws {
        // given
        let decoder = JSONDecoder()
        
        // when
        guard let firstProduct = try decoder.decode(ProductDTOList.self, from: sut).products.first else {
            XCTFail()
            return
        }
        
        // then
        XCTAssertNil(firstProduct.images)
    }
}
