//
//  WkWebView+Extensions.swift
//  ImageFeed
//
//  Created by Pavel Belenkow on 24.05.2023.
//

import Foundation
import WebKit

extension WKWebView {
    static func clean() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
}
