//
//  AlertPresenter.swift
//  ImageFeed
//
//  Created by Pavel Belenkow on 28.04.2023.
//

import UIKit

final class AlertPresenter: AlertPresenterProtocol {
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func showAlert(model: AlertModel) {
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert
        )
        
        let primaryAction = UIAlertAction(
            title: model.primaryButtonText,
            style: .default
        ) { _ in
            model.completion()
        }
        
        let secondaryAction = UIAlertAction(
            title: model.secondaryButtonText,
            style: .cancel
        )
        
        if model.secondaryButtonText != nil {
            alert.addAction(secondaryAction)
        }
        
        alert.addAction(primaryAction)
        viewController?.present(alert, animated: true)
    }
    
}
