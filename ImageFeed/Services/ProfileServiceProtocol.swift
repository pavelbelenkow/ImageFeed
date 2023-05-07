//
//  ProfileServiceProtocol.swift
//  ImageFeed
//
//  Created by Pavel Belenkow on 01.05.2023.
//

import Foundation

protocol ProfileServiceProtocol {
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void)
}
