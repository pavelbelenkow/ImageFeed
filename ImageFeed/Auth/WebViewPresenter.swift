//
//  WebViewPresenter.swift
//  ImageFeed
//
//  Created by Pavel Belenkow on 02.06.2023.
//

import Foundation

    // MARK: - Protocols

public protocol WebViewPresenterProtocol: AnyObject {
    var view: WebViewViewControllerProtocol? { get set }
    func fetchAuthorization()
    func code(from url: URL) -> String?
    func didUpdateProgressValue(_ newValue: Double)
}

    // MARK: - WebViewPresenter Class

final class WebViewPresenter: WebViewPresenterProtocol {
    
    // MARK: - Properties
    
    weak var view: WebViewViewControllerProtocol?
    var authHelper: AuthHelperProtocol
    
    // MARK: - Initializers
    
    init(authHelper: AuthHelperProtocol) {
        self.authHelper = authHelper
    }
    
    // MARK: - Methods
    
    func fetchAuthorization() {
        guard let request = authHelper.authRequest() else { return }
        view?.load(request: request)
        didUpdateProgressValue(0)
    }
    
    func code(from url: URL) -> String? {
        authHelper.code(from: url)
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
