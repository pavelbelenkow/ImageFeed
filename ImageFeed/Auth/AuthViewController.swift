//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Pavel Belenkow on 15.04.2023.
//

import UIKit

final class AuthViewController: UIViewController {
    
    // MARK: - Properties
    
    private let showWebViewSegueIdentifier = "ShowWebView"
    
    // MARK: - Segue methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWebViewSegueIdentifier {
            guard let webViewViewController = segue.destination as? WebViewViewController else {
                fatalError("Failed to prepare for \(showWebViewSegueIdentifier)")
            }
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    
    // MARK: - Delegate methods
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {}
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}

//private lazy var logoImageView: UIImageView = {
//    let imageView = UIImageView()
//    imageView.image = UIImage(named: "UnsplashLogo")
//    imageView.translatesAutoresizingMaskIntoConstraints = false
//    return imageView
//}()
//private lazy var loginButton: UIButton = {
//    let button = UIButton(type: .system)
//    button.setTitle("Войти", for: .normal)
//    button.setTitleColor(UIColor(named: "background"), for: .normal)
//    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
//    button.backgroundColor = UIColor(named: "white")
//    button.layer.masksToBounds = true
//    button.layer.cornerRadius = 16
//    button.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
//    button.translatesAutoresizingMaskIntoConstraints = false
//    return button
//}()
//private func addLogoImageView() {
//    view.addSubview(logoImageView)
//
//    NSLayoutConstraint.activate([
//        logoImageView.widthAnchor.constraint(equalToConstant: 60),
//        logoImageView.heightAnchor.constraint(equalToConstant: 60),
//        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//        logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
//    ])
//}
//
//private func addLoginButton() {
//    view.addSubview(loginButton)
//
//    NSLayoutConstraint.activate([
//        loginButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
//        loginButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
//        loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -90),
//        loginButton.heightAnchor.constraint(equalToConstant: 48)
//    ])
//}
//
//@objc
//private func didTapLoginButton() {}
