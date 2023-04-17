//
//  WebViewViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Pavel Belenkow on 16.04.2023.
//

import UIKit

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}
