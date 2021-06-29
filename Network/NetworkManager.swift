//
//  NetworkService.swift
//  TattoodoAssignment (iOS)
//
//  Created by User on 24.06.2021.
//

import Foundation

    enum NetworkResponse: String {
        case success
        case authenticationError = "You need to be authenticated first."
        case badRequest = "Bad request"
        case outdated = "The url you requested is outdated."
        case failed = "Network request failed."
        case noData = "Response returned with no data to decode."
        case unableToDecode = "We could not decode the response."
    }

    enum Result<String>{
        case success
        case failure(String)
    }

    struct NetworkManager {
        let router = Router<PostsEndpoints>()
        
        func getPosts(page: Int, completion: @escaping (_ posts: PostsResponse?,_ error: String?)->()){
            router.request(.getPosts(page: page)) { data, response, error in
                
                if error != nil {
                    completion(nil, "Please check your network connection.")
                }
                
                if let response = response as? HTTPURLResponse {
                    let result = self.handleNetworkResponse(response)
                    switch result {
                    case .success:
                        guard let responseData = data else {
                            completion(nil, NetworkResponse.noData.rawValue)
                            return
                        }
                        do {
                            let apiResponse = try JSONDecoder().decode(PostsResponse.self, from: responseData)
                            completion(apiResponse,nil)
                        }catch {
                            completion(nil, NetworkResponse.unableToDecode.rawValue)
                        }
                    case .failure(let networkFailureError):
                        completion(nil, networkFailureError)
                    }
                }
            }
        }
        
        func getRelatedPosts(page: Int, postId: Int, completion: @escaping (_ posts: RelatedPostsResponse?,_ error: String?)->()){
            router.request(.getRelatedPosts(postId: postId, page: page)) { data, response, error in
                
                if error != nil {
                    completion(nil, "Please check your network connection.")
                }
                
                if let response = response as? HTTPURLResponse {
                    let result = self.handleNetworkResponse(response)
                    switch result {
                    case .success:
                        guard let responseData = data else {
                            completion(nil, NetworkResponse.noData.rawValue)
                            return
                        }
                        do {
                            let apiResponse = try JSONDecoder().decode(RelatedPostsResponse.self, from: responseData)
                            completion(apiResponse,nil)
                        } catch {
                            completion(nil, NetworkResponse.unableToDecode.rawValue)
                        }
                    case .failure(let networkFailureError):
                        completion(nil, networkFailureError)
                    }
                }
            }
        }
        
        func getPostById(postId: Int, completion: @escaping (_ posts: PostDetailData?,_ error: String?)->()){
            router.request(.getPostDetails(postId: postId)) { data, response, error in
                if error != nil {
                    completion(nil, "Please check your network connection.")
                }
                
                if let response = response as? HTTPURLResponse {
                    let result = self.handleNetworkResponse(response)
                    switch result {
                    case .success:
                        guard let responseData = data else {
                            completion(nil, NetworkResponse.noData.rawValue)
                            return
                        }
                        do {
                            let apiResponse = try JSONDecoder().decode(PostDetailData.self, from: responseData)
                            completion(apiResponse,nil)
                        } catch {
                            completion(nil, NetworkResponse.unableToDecode.rawValue)
                        }
                    case .failure(let networkFailureError):
                        completion(nil, networkFailureError)
                    }
                }
            }
        }
        
        fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String>{
            switch response.statusCode {
            case 200...299: return .success
            case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
            case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
            case 600: return .failure(NetworkResponse.outdated.rawValue)
            default: return .failure(NetworkResponse.failed.rawValue)
            }
        }
    }
