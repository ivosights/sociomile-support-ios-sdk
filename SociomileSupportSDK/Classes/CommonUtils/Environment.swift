//
//  Environment.swift
//  scm-sdk-ios
//
//  Created by Meynisa on 06/03/24.
//

import Foundation

enum Environment {
    enum Keys {
        // swiftlint:disable nesting
        enum Plist {
            static let baseURL = "Base URL"
            static let socketURL = "Socket URL"
        }
        // swiftlint:enable nesting
    }
    
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist file not found")
        }
        return dict
    }()
    
    static let baseURL: URL = {
        guard let baseURLString = Environment.infoDictionary[Keys.Plist.baseURL] as? String else {
            fatalError("BaseURL not set in plist for this environment")
        }
        guard let url = URL(string: baseURLString) else {
            fatalError("BaseURL is invalid")
        }
        return url
    }()
    
    static let socketURL: URL = {
        guard let socketURLString = Environment.infoDictionary[Keys.Plist.socketURL] as? String else {
            fatalError("SocketURL not set in plist for this environment")
        }
        guard let url = URL(string: socketURLString) else {
            fatalError("SocketURL is invalid")
        }
        return url
    }()
}
