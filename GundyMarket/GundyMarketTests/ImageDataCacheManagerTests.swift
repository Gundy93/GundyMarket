//
//  ImageDataCacheManagerTests.swift
//  GundyMarketTests
//
//  Created by Gundy on 3/18/24.
//

import XCTest
@testable import GundyMarket

final class ImageDataCacheManagerTests: XCTestCase {
    private var sut: ImageDataCacheManager!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        sut = ImageDataCacheManager(
            memoryCache: SpyCache(cacheStorage: [:]),
            diskCache: SpyCache(cacheStorage: [:]),
            session: SpyImageSession()
        )
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        sut = nil
    }
    
    func testImageDataCacheManager_메모리캐시에_키에_맞는_데이터가_있을_경우_디스크캐시와_세션의_메서드를_호출하지_않고_메모리_캐시에_저장된_데이터를_반환한다() async {
        // given
        var storage = [String : Data]()
        let key = "circle"
        let originData = UIImage(systemName: "circle")?.jpegData(compressionQuality: 0.9)
        
        storage[key] = originData
        
        let memoryCache = SpyCache(cacheStorage: storage)
        let diskCache = SpyCache(cacheStorage: [:])
        let session = SpyImageSession() 
        
        sut = ImageDataCacheManager(
            memoryCache: memoryCache,
            diskCache: diskCache,
            session: session
        )
        
        // when
        let data = await sut.get(for: key)
        
        // then
        XCTAssertTrue(memoryCache.isCalledGetMethod)
        XCTAssertFalse(diskCache.isCalledGetMethod)
        XCTAssertFalse(session.isCalledDataTask)
        XCTAssertEqual(originData, data)
    }
    
    func testImageDataCacheManager_디스크캐시에_키에_맞는_데이터가_있을_경우_세션의_메서드를_호출하지_않고_메모리_캐시에_데이터를_저장하고_데이터를_반환한다() async {
        // given
        var storage = [String : Data]()
        let key = "square"
        let originData = UIImage(systemName: "square")?.jpegData(compressionQuality: 0.9)
        
        storage[key] = originData
        
        let memoryCache = SpyCache(cacheStorage: [:])
        let diskCache = SpyCache(cacheStorage: storage)
        let session = SpyImageSession() 
        
        sut = ImageDataCacheManager(
            memoryCache: memoryCache,
            diskCache: diskCache,
            session: session
        )
        
        // when
        let data = await sut.get(for: key)
        
        // then
        XCTAssertTrue(memoryCache.isCalledGetMethod)
        XCTAssertTrue(memoryCache.isCalledStoreMethod)
        XCTAssertTrue(diskCache.isCalledGetMethod)
        XCTAssertFalse(session.isCalledDataTask)
        XCTAssertEqual(originData, data)
    }
    
    func testImageDataCacheManager_메모리캐시와_디스크캐시_모두에_맞는_데이터가_없을_경우_세션의_메서드를_호출하고_메모리_캐시와_디스크캐시에_데이터를_저장하고_데이터를_반환한다() async {
        // given
        let memoryCache = SpyCache(cacheStorage: [:])
        let diskCache = SpyCache(cacheStorage: [:])
        let session = SpyImageSession() 
        
        sut = ImageDataCacheManager(
            memoryCache: memoryCache,
            diskCache: diskCache,
            session: session
        )
        
        // when
        let data = await sut.get(for: "key")
        
        // then
        XCTAssertTrue(memoryCache.isCalledGetMethod)
        XCTAssertTrue(memoryCache.isCalledStoreMethod)
        XCTAssertTrue(diskCache.isCalledGetMethod)
        XCTAssertTrue(diskCache.isCalledStoreMethod)
        XCTAssertTrue(session.isCalledDataTask)
        XCTAssertEqual(data, Data())
    }
    
    func testImageDataCacheManager_키에_해당하는_데이터가_캐시에_없고_적절한_URL로_변환할_수_없는_키인_경우_세션의_메서드를_호출하기_전에_nil을_반환한다() async {
        // given
        let memoryCache = SpyCache(cacheStorage: [:])
        let diskCache = SpyCache(cacheStorage: [:])
        let session = SpyImageSession() 
        
        sut = ImageDataCacheManager(
            memoryCache: memoryCache,
            diskCache: diskCache,
            session: session
        )
        
        // when
        let data = await sut.get(for: "")
        
        // then
        XCTAssertTrue(memoryCache.isCalledGetMethod)
        XCTAssertFalse(memoryCache.isCalledStoreMethod)
        XCTAssertTrue(diskCache.isCalledGetMethod)
        XCTAssertFalse(diskCache.isCalledStoreMethod)
        XCTAssertFalse(session.isCalledDataTask)
        XCTAssertNil(data)
    }
    
    func testImageDataCacheManager_세션의_dataTask를_호출한_결과가_failure인_경우_캐시에_저장하지_않고_nil을_반환한다() async {
        // given
        let memoryCache = SpyCache(cacheStorage: [:])
        let diskCache = SpyCache(cacheStorage: [:])
        let session = StubImageSession() 
        
        sut = ImageDataCacheManager(
            memoryCache: memoryCache,
            diskCache: diskCache,
            session: session
        )
        
        // when
        let data = await sut.get(for: "")
        
        // then
        XCTAssertTrue(memoryCache.isCalledGetMethod)
        XCTAssertFalse(memoryCache.isCalledStoreMethod)
        XCTAssertTrue(diskCache.isCalledGetMethod)
        XCTAssertFalse(diskCache.isCalledStoreMethod)
        XCTAssertNil(data)
    }
}
