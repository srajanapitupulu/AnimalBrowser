//
//  AnimalPhoto.swift
//  AnimalBrowser
//
//  Created by Samuel Napitupulu on 18/01/24.
//

import Foundation

struct AnimalPhoto: Codable {
    let pexel_id: Int
    let width: Int
    let height: Int
    let url: String
    let photographer: String
    let photographer_url: String
    let photographer_id: Int
    let avg_color: String
    let src_original: String
    let src_large: String
    let src_tiny: String
    let alt: String
}
