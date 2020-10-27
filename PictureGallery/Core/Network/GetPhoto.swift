//
//  GetPhoto.swift
//  PictureGallery
//
//  Created by Valeria Muldt on 26.10.2020.
//

import UIKit
import Alamofire

enum NetworkError {
    case BadStatusCode
}

class GetPhoto {
    private init() {}
    
    static let url = "http://jsonplaceholder.typicode.com/photos"
    
    static let headers: HTTPHeaders = [
        "": ""
    ]
    
    static func getArray(completion: @escaping ([GetPhotoResponse]?)->()) {
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.prettyPrinted, headers: headers, interceptor: nil, requestModifier: nil).responseString { (response) in
            guard let data = response.data,
                  let response = response.response else { return }
            
//            guard let stringData = String(data: data, encoding: .utf8) else { return }
            
//            print(stringData)
            
            if response.statusCode != 200 {
                print("error")
                completion(nil)
                return
            }
            
            do {
                let responseArray = try JSONDecoder().decode([GetPhotoResponse].self, from: data)
                DispatchQueue.main.async {
                    completion(responseArray)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    static func getImage(url: String, completion: @escaping (NetworkError?, Data?)->()) {
        AF.request(url).response { (response) in
            guard let data = response.data,
                  let response = response.response else { return }
            
            if response.statusCode != 200 {
                completion(NetworkError.BadStatusCode, nil)
                return
            }
            
            completion(nil, data)
        }
    }
    
}
