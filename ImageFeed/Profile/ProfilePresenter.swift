//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by Pavel Belenkow on 07.06.2023.
//

import Foundation
import WebKit

    // MARK: - Protocols

protocol ProfilePresenterProtocol: AnyObject {
    var view: ProfileViewControllerProtocol? { get set }
    var profile: Profile? { get }
    var imageURL: URL? { get }
    func logout()
}

    // MARK: - ProfilePresenter class

final class ProfilePresenter: ProfilePresenterProtocol {
    
    // MARK: - Properties
    
    private let profileService: ProfileServiceProtocol
    private let profileImageService: ProfileImageServiceProtocol
    private let tokenStorage: OAuth2TokenStorageProtocol
    weak var view: ProfileViewControllerProtocol?
    
    var profile: Profile? {
        profileService.profile
    }
    
    var imageURL: URL? {
        URL(string: profileImageService.avatarURL ?? String())
    }
    
    // MARK: - Initializers
    
    init(
        profileService: ProfileService = .shared,
        profileImageService: ProfileImageService = .shared,
        tokenStorage: OAuth2TokenStorage = .shared,
        view: ProfileViewControllerProtocol
    ) {
        self.profileService = profileService
        self.profileImageService = profileImageService
        self.tokenStorage = tokenStorage
        self.view = view
    }
    
    // MARK: - Methods
    
    func logout() {
        tokenStorage.removeToken()
        WKWebView.clean()
        
        guard let window = UIApplication.shared.windows.first else { return }
        let splashViewController = SplashViewController()
        window.rootViewController = splashViewController
    }
}
