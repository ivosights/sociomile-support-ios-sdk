//
//  SendResponse.swift
//  scm-sdk-ios
//
//  Created by Meynisa on 06/03/24.
//

import Foundation

struct SendResponse: Codable {
    var status: Bool?
    var message: String?
    var data: SendData?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.status = try container.decodeIfPresent(Bool.self, forKey: .status)
        self.message = try container.decodeIfPresent(String.self, forKey: .message)
        self.data = try container.decodeIfPresent(SendData.self, forKey: .data)
    }
}

struct SendData: Codable {
    var id: String?
    var number: Int?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.number = try container.decodeIfPresent(Int.self, forKey: .number)
    }
}

struct ReadResponse: Codable{
    var status: Bool?
    var message: String?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.status = try container.decodeIfPresent(Bool.self, forKey: .status)
        self.message = try container.decodeIfPresent(String.self, forKey: .message)
    }
}
