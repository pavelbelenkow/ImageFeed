//
//  WebViewPresenter.swift
//  ImageFeed
//
//  Created by Pavel Belenkow on 02.06.2023.
//

import Foundation

// MARK: - Protocols

protocol WebViewPresenterProtocol: AnyObject {
    var view: WebViewViewControllerProtocol? { get set }
    func fetchAuthorization()
    func code(from url: URL) -> String?
    func didUpdateProgressValue(_ newValue: Double)
}

// MARK: - WebViewPresenter Class

final class WebViewPresenter: WebViewPresenterProtocol {
    
    // MARK: - Properties
    
    weak var view: WebViewViewControllerProtocol?
    
    // MARK: - Methods
    
    func fetchAuthorization() {
        guard var urlComponents = URLComponents(string: Constants.unsplashAuthorizeURL) else {
            return
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: Constants.accessScope)
        ]
        
        guard let url = urlComponents.url else {
            return
        }
        
        didUpdateProgressValue(0)
        
        let request = URLRequest(url: url)
        view?.load(request: request)
    }
    
    func code(from url: URL) -> String? {
        if
            let urlComponent = URLComponents(string: url.absoluteString),
            urlComponent.path == "/oauth/authorize/native",
            let items = urlComponent.queryItems,
            let codeItem = items.first(where: { $0.name == "code" })
        {
            return codeItem.value
        } else {
            return nil
        }
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)
        
        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(shouldHideProgress)
    }
    
    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
}
