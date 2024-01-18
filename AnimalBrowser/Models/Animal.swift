//
//  Animal.swift
//  AnimalBrowser
//
//  Created by Samuel Napitupulu on 18/01/24.
//

import Foundation

struct Animal:Codable {
    let name: String
    let areas: [String]
    let taxonomy: Taxonomy
    let characteristics: Characteristic
    
    enum CodingKeys: String, CodingKey {
        case name
        case areas = "locations"
        case taxonomy
        case characteristics
    }
    
    init(name: String,
         areas: [String],
         taxonomy: Taxonomy,
         characteristics: Characteristic) {
        
        self.name = name
        self.areas = areas
        self.taxonomy = taxonomy
        self.characteristics = characteristics
    }
}

struct Taxonomy:Codable {
    let kingdom: String
    let phylum: String
    let animalclass: String?
    let order: String?
    let family: String?
    let genus: String?
    let scientific_name: String?
    
    enum CodingKeys: String, CodingKey {
        case kingdom
        case phylum
        case animalclass = "class"
        case order
        case family
        case genus
        case scientific_name
    }
    
    init(kingdom: String,
         phylum: String,
         animalclass: String?,
         order: String?,
         family: String?,
         genus: String?,
         scientific_name: String?) {
        
        self.kingdom = kingdom
        self.phylum = phylum
        self.animalclass = animalclass
        self.order = order
        self.family = family
        self.genus = genus
        self.scientific_name = scientific_name
    }
}

struct Characteristic:Codable {
    let habitat: String?
    let diet: String?
    let location: String?
    let color: String?
    let top_speed: String?
    let lifespan: String?
    let weight: String?
    let height: String?
    let length: String?
    
    enum CodingKeys: String, CodingKey {
        case habitat
        case diet
        case location
        case color
        case top_speed
        case lifespan
        case weight
        case height
        case length
    }
    
    init(habitat: String?,
         diet: String?,
         location: String?,
         color: String?,
         top_speed: String?,
         lifespan: String?,
         weight: String?,
         height: String?,
         length: String?) {
        
        self.habitat = habitat
        self.diet = diet
        self.location = location
        self.color = color
        self.top_speed = top_speed
        self.lifespan = lifespan
        self.weight = weight
        self.height = height
        self.length = length
    }
    
    
    
    
}
