//
//  AnimalPhoto.swift
//  AnimalBrowser
//
//  Created by Samuel Napitupulu on 18/01/24.
//

import Foundation

struct AnimalPhotoResult: Codable {
    let page: Int
    let total_results: Int
    var photos: [AnimalPhoto]
    let next_page: String
}

struct PhotoSource: Codable {
    let original: String
    let large: String
    let tiny: String
}

struct AnimalPhoto: Codable {
    let pexel_id: Int
    var liked: Bool
    let width: Int
    let height: Int
    let url: String
    let photographer: String
    let photographer_url: String
    let photographer_id: Int
    let avg_color: String
    let src: PhotoSource
    let alt: String
    
    enum CodingKeys: String, CodingKey {
        case pexel_id = "id"
        case liked
        case width
        case height
        case url
        case photographer
        case photographer_url
        case photographer_id
        case avg_color
        case src
        case alt
    }
    
    init(pexel_id: Int,
         liked: Bool,
         width: Int,
         height: Int,
         url: String,
         photographer: String,
         photographer_url: String,
         photographer_id: Int,
         avg_color: String,
         src: PhotoSource,
         alt: String) {
        
        self.pexel_id = pexel_id
        self.liked = liked
        self.width = width
        self.height = height
        self.url = url
        self.photographer = photographer
        self.photographer_url = photographer_url
        self.photographer_id = photographer_id
        self.avg_color = avg_color
        self.src = src
        self.alt = alt
    }
}
