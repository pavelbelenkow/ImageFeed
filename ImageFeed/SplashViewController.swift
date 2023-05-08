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
    
    private let showAuthScreenSegueIdentifier = "ShowAuthenticationScreen"
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let oauth2TokenStorage = OAuth2TokenStorage.shared
    
    // MARK: - Lifecycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkAuthorization()
    }
    
    // MARK: - Methods
    
    private func checkAuthorization() {
        if let token = oauth2TokenStorage.token {
            fetchProfile(token: token)
        } else {
            performSegue(withIdentifier: showAuthScreenSegueIdentifier, sender: nil)
        }
    }
    
    private func fetchProfile(token: String) {
        UIBlockingProgressHUD.show()
        
        profileService.fetchProfile(token) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let profile):
                self.switchToTabBarController()
                UIBlockingProgressHUD.dismiss()
                profileImageService.fetchProfileImageURL(username: profile.username) { _ in }
            case .failure(let error):
                let alert = AlertModel(
                    title: "Не удалось получить данные профиля",
                    message: error.localizedDescription,
                    buttonText: "Попробовать ещё раз"
                ) { [weak self] in
                    guard let self else { return }
                    self.fetchProfile(token: token)
                }
                
                AlertPresenter(viewController: self).showAlert(model: alert)
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
}

extension SplashViewController {
    
    // MARK: - Segue methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showAuthScreenSegueIdentifier {
            guard let navigationController = segue.destination as? UINavigationController,
                  let viewController = navigationController.viewControllers[0] as? AuthViewController
            else {
                assertionFailure("Failed to prepare for \(showAuthScreenSegueIdentifier)")
                return
            }
            
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    
    // MARK: - Delegate methods
    
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        checkAuthorization()
    }
}
