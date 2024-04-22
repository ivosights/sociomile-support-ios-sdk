//
//  MessageServices.swift
//  scm-sdk-ios
//
//  Created by Meynisa on 06/03/24.
//

import Foundation
import Alamofire
import UIKit

enum MessageService: URLRequestConvertible {
    
    case getUserProfile
    case getConversations(_ page: Int)
    case sendMessages(_ parameters: Parameters)
    case readMessages
    
    // MARK: - HTTPMethod
    private var method: HTTPMethod {
        switch self {
        case .getConversations(_):
            return .get
        default:
            return .post
        }
    }
    
    // MARK: - Path
    private var path: String {
        switch self {
        case .getUserProfile:
            return "userservice/getuserdatainformation"
        case .getConversations(_):
            return "/sdk/conversation"
        case .sendMessages:
            return "/sdk/send"
        case .readMessages:
            return "/sdk/read"
        }
    }
    
    // MARK: - Parameters
    private var parameters: Parameters? {
        switch self {
        case .getUserProfile, .readMessages:
            return [:]
        case .getConversations(let param):
            return [
                "page": param
            ] as [String: Any]
        case .sendMessages(let param):
            return param as Parameters
        }
    }
    
    // MARK: - Header
    
    private var header: [String: String] {
        
        let applicationVersion = Constants.getVersionNumber()
        // swiftlint:disable:next discouraged_direct_init
        let deviceName = UIDevice().name
        let osName =  Constants.osName
        let brand = "Apple"
        
        switch self {
        case .getUserProfile, .getConversations, .sendMessages, .readMessages:
            let params = [
                "SM-UserId": "\(AppSetting.shared.userId)",
                "FCM-Token": "\(AppSetting.shared.fcmToken)",
                "Content-Type": "application/json"
            ]
            return params
        }
    }
    
    // MARK: - With Auth
    
    private var withAuth: Bool {
        switch self {
        default:
            return false
        }
    }
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try "\(Constants.baseUrl)".asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.timeoutInterval = 90
        
        // Http method
        urlRequest.httpMethod = method.rawValue
        
        // Http header
        urlRequest.headers = AppSetting.shared.prepareHeader(withAuth: withAuth)
        for h in header {
            urlRequest.setValue(h.value, forHTTPHeaderField: h.key)
        }
        
        let clientName = AppSetting.shared.clientName//"AAA"
        let clientKey = AppSetting.shared.clientKey//"BBB"
        let loginString = String(format: "%@:%@", clientName, clientKey)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        
        urlRequest.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        // Encoding
        let encoding: ParameterEncoding = {
            switch method {
            case .get:
                return URLEncoding.default
            default:
                return JSONEncoding.default
            }
        }()
        
        return try encoding.encode(urlRequest, with: parameters)
    }
}
