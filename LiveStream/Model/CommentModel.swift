//
//  CommentModel.swift
//  LiveStream
//
//  Created by Abhishek Kumar Singh on 20/12/24.
//

import Foundation

struct CommentModel: Decodable {
    let comments: [Comment]
}

struct Comment: Decodable {
    let username: String
    let picURL: String
    let comment: String
}

