//
//  MockResource.swift
//  LiveStream
//
//  Created by Abhishek Kumar Singh on 21/12/24.
//

import Foundation

struct Resource {
    private func loadMockJSON(fileName: String) -> Data? {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            debugPrint("Mock JSON file not found")
            return nil
        }
        
        return try? Data(contentsOf: url)
    }

    func parseMockJSON<T:Decodable>(fileName: String, resultType: T.Type,completionHandler:@escaping(_ result: T?)-> Void) {
        if let data = loadMockJSON(fileName: fileName) {
            do {
                let response = try JSONDecoder().decode(T.self, from: data)
                _=completionHandler(response)
            } catch {
                _=completionHandler(nil)
            }
        }
    }
}
