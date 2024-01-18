//
//  APIs.swift
//  AnimalBrowser
//
//  Created by Samuel Napitupulu on 18/01/24.
//

import Foundation

protocol API {
    static var baseUrl: String { get }
    static var baseAPIKey: String { get }
    static var baseAPIHeader: String { get }
}

enum APIs {
    enum AnimalsAPI: API {
        static var baseUrl = "https://api.api-ninjas.com/v1/animals?name="
//        static var baseUrl = URL(string: "https://api.api-ninjas.com/v1/animals")!
        static var baseAPIKey = "pfFQJxLiPMYqvY5rZXbYdw==VBjYVanTRFZdEhx9"
        static var baseAPIHeader = "x-api-key"
        
        static func getAnimalName(name: String) -> URL {
            return URL(string: APIs.AnimalsAPI.baseUrl + name)!
        }
        
        
    }
    
//    enum PexelsAPI: RawRepresentable, API {
//        init?(rawValue: String) { nil }
//        
//        static var baseUrl = URL(string: "https://api.pexels.com/v1/search?")!
//        static var baseAPIKey = "F0RsC7L6viQO7bzFmZTKs7hwGWhXlwm5TjAozyXUwkTmB8INisxbwjVg"
//        static var baseAPIHeader = "Authorization"
//        
//        case getAnimalPictures(name: String)
//        
//        var rawValue: String {
//            switch self {
//            case .getAnimalPictures(let name): return "query=\(name)&per_page=10"
//            }
//        }
//    }
}

