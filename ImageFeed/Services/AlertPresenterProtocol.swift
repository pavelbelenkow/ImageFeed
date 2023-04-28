//
//  AlertPresenterProtocol.swift
//  ImageFeed
//
//  Created by Pavel Belenkow on 28.04.2023.
//

import UIKit

protocol AlertPresenterProtocol: AnyObject {
    func showAlert(model: AlertModel)
}
