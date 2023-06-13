//
//  ImagesListTests.swift
//  ImageFeedTests
//
//  Created by Pavel Belenkow on 06.06.2023.
//

import XCTest
@testable import ImageFeed

final class ImagesListServiceMock: ImagesListServiceProtocol {
    var photos: [ImageFeed.Photo] = []
    
    var fetchPhotosNextPageCalled: Bool = false
    var changeLikeCalled: Bool = false
    
    func fetchPhotosNextPage(completion: @escaping (Result<[ImageFeed.Photo], Error>) -> Void) {
        fetchPhotosNextPageCalled = true
    }
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        changeLikeCalled = true
    }
}

final class ImagesListTests: XCTestCase {
    
    func testImagesListPresenterCallsFetchPhotos() {
        // given
        let viewController = ImagesListViewController()
        let service = ImagesListServiceMock()
        let sut = ImagesListPresenter(viewController: viewController, imagesListService: service)
       
        // when
        sut.presentPhotosNextPage()
        
        // then
        XCTAssertTrue(service.fetchPhotosNextPageCalled)
    }
    
    func testImagesListPresenterCallsChangeLike() {
        // given
        let viewController = ImagesListViewController()
        let service = ImagesListServiceMock()
        let sut = ImagesListPresenter(viewController: viewController, imagesListService: service)
        
        // when
        sut.presentChangeLikeResult(
            photo: Photo(
                id: String(),
                size: CGSize(),
                createdAt: Date(),
                welcomeDescription: String(),
                thumbImageURL: String(),
                largeImageURL: String(),
                isLiked: Bool()
            )) { _ in }
        
        // then
        XCTAssertTrue(service.changeLikeCalled)
    }
}
