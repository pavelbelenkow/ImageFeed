//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Pavel Belenkow on 15.04.2023.
//

import UIKit
import WebKit

final class WebViewViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private var webView: WKWebView!
    
    // MARK: - Properties
    
    weak var delegate: WebViewViewControllerDelegate?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        
        guard var urlComponents = URLComponents(string: Constants.unsplashAuthorizeURLString.rawValue) else {
            return
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey.rawValue),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI.rawValue),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: Constants.accessScope.rawValue)
        ]
        
        guard let url = urlComponents.url else {
            return
        }
        
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    // MARK: - Actions
    
    @IBAction private func didTapBackButton(_ sender: Any?) {
        delegate?.webViewViewControllerDidCancel(self)
    }
}

extension WebViewViewController: WKNavigationDelegate {
    
    // MARK: - Navigation Delegate methods
    
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url,
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
}
