//
//  HTTPService.swift
//  TattoodoAssignment (iOS)
//
//  Created by User on 24.06.2021.
//

import Foundation

protocol RequestType {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
}

public typealias HTTPParameters = [String: Any]

enum HTTPMethod: String {
    case get = "GET"
}

enum HTTPTask {
    case request
    case requestWithParameters(bodyParameters: HTTPParameters?, urlParameters: HTTPParameters?)
}
