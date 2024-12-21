//
//  MockDataViewModel.swift
//  LiveStream
//
//  Created by Abhishek Kumar Singh on 21/12/24.
//

import Foundation

final class MockDataViewModel {
    var resource = Resource()
    
    func loadMockVideoData(completion : @escaping (_ result: VideoModel?) -> Void) {
        resource.parseMockJSON(fileName: "VideoMockData", resultType: VideoModel.self) { result in
            _ = completion(result)
        }
    }
    
    func loadCommentMockData(completion : @escaping (_ result: CommentModel?) -> Void) {
        resource.parseMockJSON(fileName: "CommentMockData", resultType: CommentModel.self) { result in
            _ = completion(result)
        }
    }
}
