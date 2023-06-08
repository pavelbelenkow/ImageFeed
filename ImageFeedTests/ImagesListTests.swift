//
//  ImagesListTests.swift
//  ImageFeedTests
//
//  Created by Pavel Belenkow on 06.06.2023.
//

import XCTest
@testable import ImageFeed

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    var view: ImageFeed.ImagesListViewControllerProtocol?
    
    var photosCalled: Bool = false
    var presentPhotosNextPageCalled: Bool = false
    
    var photos: [ImageFeed.Photo] {
        photosCalled = true
        return []
    }
    
    func presentPhotosNextPage() {
        presentPhotosNextPageCalled = true
    }
    
    func presentChangeLikeResult(photo: ImageFeed.Photo, completion: @escaping (Result<Void, Error>) -> Void) {}
    }

final class ImagesListTests: XCTestCase {
    
    func testImagesListViewControllerCallsPhotos() {
        // given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as! ImagesListViewController
        
        let presenter = ImagesListPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        // when
        _ = viewController.view
        
        // then
        XCTAssertTrue(presenter.photosCalled)
    }
    
    func testImagesListViewControllerCallsPresentPhotosNextPage() {
        // given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as! ImagesListViewController
        
        let presenter = ImagesListPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        // when
        _ = viewController.view
        
        // then
        XCTAssertTrue(presenter.presentPhotosNextPageCalled)
    }
}
