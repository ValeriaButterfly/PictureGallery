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
    
    static func getArray(completion: @escaping ([GetPhotoResponse]?, NetworkError?)->()) {
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.prettyPrinted, headers: nil, interceptor: nil, requestModifier: nil).responseString { (response) in
            guard let data = response.data,
                  let response = response.response else { return }
            
            if response.statusCode != 200 {
                print("error")
                completion(nil, NetworkError.BadStatusCode)
                return
            }
            
            do {
                let responseArray = try JSONDecoder().decode([GetPhotoResponse].self, from: data)
                DispatchQueue.main.async {
                    completion(responseArray, nil)
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
