//
//  APIHelper.swift
//  AnimalBrowser
//
//  Created by Samuel Napitupulu on 18/01/24.
//

import Foundation

struct APIHelper {
    static func fetchAnimalData(animalName: String, completionHandler: @escaping ([Animal]) -> Void) {
        let url = APIs.AnimalsAPI.getAnimalName(name: animalName)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(APIs.AnimalsAPI.baseAPIKey, forHTTPHeaderField: APIs.AnimalsAPI.baseAPIHeader)
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            if let error = error {
                print("Error with fetching animal data: \(error)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Error with the response, unexpected status code: \(String(describing: response))")
                return
            }
            
            do {
                let dataResult = data
                let animalSummary = try! JSONDecoder().decode([Animal].self, from: dataResult!)
                completionHandler(animalSummary)
            }
            catch {
                print("Unexpected error: \(error).")
            }
        })
        task.resume()
    }
    
    static func fetchAnimalPhotos(animalName: String, completionHandler: @escaping (AnimalPhotoResult) -> Void) {
        let url = APIs.PexelsAPI.getAnimalPictures(name: animalName)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(APIs.PexelsAPI.baseAPIKey, forHTTPHeaderField: APIs.PexelsAPI.baseAPIHeader)
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            if let error = error {
                print("Error with fetching animal photos: \(error)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Error with the response, unexpected status code: \(String(describing: response))")
                return
            }
           
//            if let data = data,
//               let animalPhotoResult = try? JSONDecoder().decode(AnimalPhotoResult.self, from: data) {
//                completionHandler(animalPhotoResult)
//            }
            
            do {
                let dataResult = data
                let animalPhotoResult = try! JSONDecoder().decode(AnimalPhotoResult.self, from: dataResult!)
                completionHandler(animalPhotoResult)
            }
            catch {
                print("Unexpected error: \(error).")
            }
        })
        task.resume()
    }
}
