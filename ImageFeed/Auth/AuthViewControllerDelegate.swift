//
//  AuthViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Pavel Belenkow on 21.04.2023.
//

import Foundation

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}
