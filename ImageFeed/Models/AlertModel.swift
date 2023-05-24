//
//  AlertModel.swift
//  ImageFeed
//
//  Created by Pavel Belenkow on 28.04.2023.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let primaryButtonText: String
    let secondaryButtonText: String?
    let completion: () -> Void?
}
