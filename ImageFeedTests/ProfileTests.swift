//
//  ProfileTests.swift
//  ImageFeedTests
//
//  Created by Pavel Belenkow on 07.06.2023.
//

import XCTest
@testable import ImageFeed

final class ProfilePresenterSpy: ProfilePresenterProtocol {

    var view: ProfileViewControllerProtocol?
    
    var imagURLCalled: Bool = false
    var profileCalled: Bool = false
    
    var imageURL: URL? {
        imagURLCalled = true
        return URL(string: String())
    }
    var profile: Profile? {
        profileCalled = true
        return Profile(username: String(), name: String(), loginName: String(), bio: String())
    }
    
    func logout() {}
}

final class ProfileTests: XCTestCase {
    
    func testProfileViewControllerCallsImageURL() {
        // given
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        
        viewController.presenter = presenter
        presenter.view = viewController
        
        // when
        _ = viewController.view
        
        // then
        
        XCTAssertTrue(presenter.imagURLCalled)
    }
    
    func testProfileViewControllerCallsProfile() {
        // given
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        
        viewController.presenter = presenter
        presenter.view = viewController
        
        // when
        _ = viewController.view
        
        // then
        XCTAssertTrue(presenter.profileCalled)
    }
}
