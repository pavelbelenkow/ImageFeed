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
    var photos: [ImageFeed.Photo] {
        photosCalled = true
        return []
    }
    
    var presentPhotosNextPageCalled: Bool = false
    var presentChangeLikeResultCalled: Bool = false
    
    func presentPhotosNextPage() {
        presentPhotosNextPageCalled = true
    }
    
    func presentChangeLikeResult(photo: ImageFeed.Photo, completion: @escaping (Result<Void, Error>) -> Void) {
        presentChangeLikeResultCalled = true
    }
    
    
    }

//final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
//    var tableView: UITableView = UITableView()
//    var presenter: ImagesListPresenterProtocol = ImagesListPresenterSpy()
//    var photos: [Photo] = [Photo(id: String(),
//                                 size: CGSize(width: 600, height: 700),
//                                 createdAt: Date(),
//                                 welcomeDescription: String(),
//                                 thumbImageURL: String(),
//                                 largeImageURL: String(),
//                                 isLiked: Bool())
//    ]
//
//    func updateTableViewAnimated() {
//        tableView.performBatchUpdates {
//            let oldCount = photos.count
//            let newCount = presenter.photos.count
//            photos = presenter.photos
//            if oldCount != newCount {
//                tableView.performBatchUpdates {
//                    var indexPaths: [IndexPath] = []
//                    (oldCount..<newCount).forEach { index in
//                        indexPaths.append(IndexPath(row: index, section: 0))
//                    }
//                    tableView.insertRows(at: indexPaths, with: .automatic)
//                } completion: { _ in }
//            }
//        }
//    }
//}

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
        _ = viewController.updateTableViewAnimated()
        
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
    
    func testImagesListViewControllerCallsPresentChangeLikeResult() {
        // given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as! ImagesListViewController
//        let viewController = ImagesListViewControllerSpy()
        let presenter = ImagesListPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        viewController.photos = [
            Photo(id: String(),
                  size: CGSize(width: 600, height: 700),
                  createdAt: Date(),
                  welcomeDescription: String(),
                  thumbImageURL: String(),
                  largeImageURL: String(),
                  isLiked: Bool())
        ]
        
        // when
        _ = viewController.view
        
        let cell = viewController.tableView(viewController.tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        _ = viewController.imageListCellDidTapLike(cell as! ImagesListCell)
        
        // then
        XCTAssertTrue(presenter.presentChangeLikeResultCalled)
    }
}
