//
//  APIs.swift
//  AnimalBrowser
//
//  Created by Samuel Napitupulu on 18/01/24.
//

import Foundation

let API_NINJA_KEY = "pfFQJxLiPMYqvY5rZXbYdw==VBjYVanTRFZdEhx9"
let PEXELS_KEY = "F0RsC7L6viQO7bzFmZTKs7hwGWhXlwm5TjAozyXUwkTmB8INisxbwjVg"

protocol API {
    static var baseUrl: String { get }
    static var baseAPIKey: String { get }
    static var baseAPIHeader: String { get }
}

enum APIs {
    enum AnimalsAPI: API {
        static var baseUrl = "https://api.api-ninjas.com/v1/animals?name="
        
        static var baseAPIKey = API_NINJA_KEY
        static var baseAPIHeader = "x-api-key"
        
        static func getAnimalName(name: String) -> URL {
            return URL(string: APIs.AnimalsAPI.baseUrl + name)!
        }
        
        
    }
    
    enum PexelsAPI: API {
        static var baseUrl = "https://api.pexels.com/v1/search?"
        static var baseAPIKey = PEXELS_KEY
        static var baseAPIHeader = "Authorization"
        
        static func getAnimalPictures(name: String, pageNum: Int = 1) -> URL {
            return URL(string: APIs.PexelsAPI.baseUrl + "query=\(name)&page=\(pageNum)&per_page=42")!
        }
    }
}

