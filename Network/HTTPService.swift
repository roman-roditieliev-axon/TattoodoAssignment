//
//  HTTPService.swift
//  TattoodoAssignment (iOS)
//
//  Created by User on 24.06.2021.
//

import Foundation

// MARK: - RequestType
protocol RequestType {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
}

// MARK: - HTTPParameters
public typealias HTTPParameters = [String: Any]

// MARK: - HTTPMethod
enum HTTPMethod: String {
    case get = "GET"
}

// MARK: - HTTPTask
enum HTTPTask {
    case request
    case requestWithParameters(bodyParameters: HTTPParameters?, urlParameters: HTTPParameters?)
}
