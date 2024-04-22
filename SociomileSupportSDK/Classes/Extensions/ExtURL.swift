//
//  ExtURL.swift
//  scm-sdk-ios
//
//  Created by Meynisa on 06/03/24.
//

import Foundation

extension URL {
    var typeIdentifier: String? {
        return (try? resourceValues(forKeys: [.typeIdentifierKey]))?.typeIdentifier
    }
    var localizedName: String? {
        return (try? resourceValues(forKeys: [.localizedNameKey]))?.localizedName
    }
}
