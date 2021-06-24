//
//  NetworkRouter.swift
//  TattoodoAssignment (iOS)
//
//  Created by User on 24.06.2021.
//

import Foundation

public typealias NetworkRouterCompletion = (_ data: Data?,_ response: URLResponse?,_ error: Error?)->()

protocol NetworkRouter: class {
    associatedtype EndPoint: RequestType
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion)
    func cancel()
}

class Router<EndPoint: RequestType>: NetworkRouter {
    
    private var task: URLSessionTask?
    
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion) {
        let session = URLSession.shared
        do {
            let request = try self.buildRequest(from: route)
            NetworkLogger.log(request: request)
            task = session.dataTask(with: request, completionHandler: { data, response, error in
              completion(data, response, error)
            })
        }catch {
            completion(nil, nil, error)
        }
        self.task?.resume()
    }
    
    func cancel() {
        self.task?.cancel()
    }
    
    fileprivate func buildRequest(from route: EndPoint) throws -> URLRequest {
        var request = URLRequest(url: route.baseURL.appendingPathComponent(route.path),
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 10.0)
        switch route.task {
        case .request:
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        case .requestWithParameters(let bodyParameters, let urlParameters):
            print(bodyParameters)
            print(urlParameters)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            try self.configureParameters(bodyParameters: bodyParameters,
                                         urlParameters: urlParameters,
                                         request: &request)
        }
        return request
    }
    
    fileprivate func configureParameters(bodyParameters: Parameters?, urlParameters: Parameters?, request: inout URLRequest) throws {
        do {
            if let bodyParameters = bodyParameters {
                try JSONParameterEncoder().encode(urlRequest: &request, with: bodyParameters)
            }
            if let urlParameters = urlParameters {
                try URLParameterEncoder().encode(urlRequest: &request, with: urlParameters)
            }
        } catch {
            throw error
        }
    }
}
