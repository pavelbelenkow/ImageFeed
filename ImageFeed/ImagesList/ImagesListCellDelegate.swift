//
//  ImagesListCellDelegate.swift
//  ImageFeed
//
//  Created by Pavel Belenkow on 24.05.2023.
//

import Foundation

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}
