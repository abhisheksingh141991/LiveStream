//
//  VideoModel.swift
//  LiveStream
//
//  Created by Abhishek Kumar Singh on 20/12/24.
//

import Foundation

struct VideoModel: Decodable {
    let videos: [Video]
}

struct Video: Decodable {
    let id: Int
    let userID: Int
    let username: String
    let profilePicURL: String
    let description: String
    let topic: String
    let viewers: Int
    let likes: Int
    let video: String
    let thumbnail: String
}
