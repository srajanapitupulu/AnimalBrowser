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
        print(url.absoluteString)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(APIs.AnimalsAPI.baseAPIKey, forHTTPHeaderField: APIs.AnimalsAPI.baseAPIHeader)
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            if let error = error {
                print("Error with fetching films: \(error)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Error with the response, unexpected status code: \(String(describing: response))")
                return
            }
            
            //          if let data = data,
            //            let animalSummary = try? JSONDecoder().decode(AnimalSummary.self, from: data) {
            //              print(animalSummary)
            //            completionHandler(animalSummary.results ?? [])
            //          }
            
            
            do {
                let dataResult = data
                print("Unexpected dataResult: \(String(describing: dataResult)).")
                let animalSummary = try! JSONDecoder().decode([Animal].self, from: dataResult!)
                completionHandler(animalSummary)
            }
            catch {
                print("Unexpected error: \(error).")
            }
            
            
            
            
        })
        task.resume()
    }
}
