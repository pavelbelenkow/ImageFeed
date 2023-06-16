//
//  WebViewPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Pavel Belenkow on 05.06.2023.
//

import Foundation
import ImageFeed

final class WebViewPresenterSpy: WebViewPresenterProtocol {
    var fetchAuthorizationCalled: Bool = false
    var view: WebViewViewControllerProtocol?
    
    func fetchAuthorization() {
        fetchAuthorizationCalled = true
    }
    
    func code(from url: URL) -> String? {
        nil
    }
    
    func didUpdateProgressValue(_ newValue: Double) {}
}
