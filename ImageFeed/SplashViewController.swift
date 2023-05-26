//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Pavel Belenkow on 21.04.2023.
//

import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    
    // MARK: - Properties
    
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let oauth2TokenStorage = OAuth2TokenStorage.shared
    private var alertPresenter: AlertPresenterProtocol?
    
    private lazy var splashLogoView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "LaunchScreen")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.backgroundColor = UIColor(named: "background")
        addSplashLogoView()
        alertPresenter = AlertPresenter(viewController: self)
        checkAuthorization()
    }
    
    // MARK: - Methods
    
    private func checkAuthorization() {
        if let token = oauth2TokenStorage.token {
            fetchProfile(token: token)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: .main)
            
            guard
                let authViewController = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController
            else { return }
            
            authViewController.delegate = self
            authViewController.modalPresentationStyle = .fullScreen
            present(authViewController, animated: true)
        }
    }
    
    private func fetchProfile(token: String) {
        UIBlockingProgressHUD.show()
        
        profileService.fetchProfile(token) { [weak self] result in
            guard let self else { return }
            
            UIBlockingProgressHUD.dismiss()
            switch result {
            case .success(let profile):
                self.switchToTabBarController()
                profileImageService.fetchProfileImageURL(token: token, username: profile.username) { _ in }
                UIBlockingProgressHUD.dismiss()
            case .failure(let error):
                let alert = AlertModel(
                    title: "Не удалось получить данные профиля",
                    message: error.localizedDescription,
                    buttonText: "Ок"
                ) { [weak self] in
                    guard let self else { return }
                    self.fetchProfile(token: token)
                }
                
                alertPresenter?.showAlert(model: alert)
            }
        }
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            fatalError("Invalid Configuration")
        }
        
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        
        window.rootViewController = tabBarController
    }
    
    private func addSplashLogoView() {
        view.addSubview(splashLogoView)
        
        splashLogoView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        splashLogoView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    
    // MARK: - Delegate methods
    
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        checkAuthorization()
    }
}
