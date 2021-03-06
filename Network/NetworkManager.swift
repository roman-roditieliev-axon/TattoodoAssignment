//
//  NetworkService.swift
//  TattoodoAssignment (iOS)
//
//  Created by User on 24.06.2021.
//

import Foundation

typealias ResponseData<T: Equatable> = Result<[T], Error>

struct NetworkManager {
    let router = Router<PostsEndpoints>()
    
    func getPosts<T: Decodable>(page: Int, completion: @escaping(ResponseData<T>) -> Void) {
        router.request(.getPosts(page: page)) { data, response, error in
            
            if let strError = error {
                completion(.failure(strError))
            }
            
            if let jsonData = data {
                do {
                    let decoder = JSONDecoder()
                    let userResponse = try decoder.decode(PostsResponse<T>.self, from: jsonData)
                    let postListData = userResponse.data
                    completion(.success(postListData))
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func getRelatedPosts<T: Decodable>(page: Int, postId: Int, completion: @escaping(ResponseData<T>) -> Void) {
        router.request(.getRelatedPosts(postId: postId, page: page)) { data, response, error in
            
            if let strError = error {
                completion(.failure(strError))
            }
            
            if let jsonData = data {
                do {
                    let decoder = JSONDecoder()
                    let userResponse = try decoder.decode(PostsResponse<T>.self, from: jsonData)
                    let postListData = userResponse.data
                    completion(.success(postListData))
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func getPostById(postId: Int, completion: @escaping(Result<PostDetailData?, Error>) -> Void) {
        router.request(.getPostDetails(postId: postId)) { data, response, error in
            if let strError = error {
                completion(.failure(strError))
            }
            
            if let jsonData = data {
                do {
                    let decoder = JSONDecoder()
                    let userResponse = try decoder.decode(PostDetailData.self, from: jsonData)
                    completion(.success(userResponse))
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }
}
