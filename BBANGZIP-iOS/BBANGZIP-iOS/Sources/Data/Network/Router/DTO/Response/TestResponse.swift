//
//  TestResponse.swift
//  BBANGZIP
//
//  Created by 조성민 on 5/17/25.
//

struct TestResponseDTO: Decodable {
    let postId: Int
    let id: Int
    let name: String
    let email: String
    let body: String
}
