//
//  GetPhotoResponse.swift
//  PictureGallery
//
//  Created by Valeria Muldt on 26.10.2020.
//

import Foundation

struct GetPhotoResponse: Decodable {
    let albumId: Int
    let id: Int
    let title: String
    let url: String
    let thumbnailUrl: String
}
