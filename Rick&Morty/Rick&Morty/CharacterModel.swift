//
//  CharacterModel.swift
//  Rick&Morty
//
//  Created by Dsilva on 06/07/19.
//  Copyright © 2019 Dsilva. All rights reserved.
//

import UIKit

class CharacterModel: NSObject {
    
    
    enum Status {
        case alive
        case dead
    }
    enum Gender {
        case male
        case female
        case unknown
    }
    
    var id:Int
    var name:String
    var status:Status
    var species: String
    var type: String
    var gender:Gender
    var origin:[String:String]
    var location:[String:String]
    var imageUrl:String
    var episodeAppeared:[String]
    var url:String
    var created:String
    
    init(id: Int, name: String, status: CharacterModel.Status, species: String, type: String, gender: CharacterModel.Gender, origin: [String : String], location: [String : String], imageUrl: String, episodeAppeared: [String], url: String, created: String) {
        self.id = id
        self.name = name
        self.status = status
        self.species = species
        self.type = type
        self.gender = gender
        self.origin = origin
        self.location = location
        self.imageUrl = imageUrl
        self.episodeAppeared = episodeAppeared
        self.url = url
        self.created = created
    }

    init?(json: [String: Any]) {
        
        guard let id = json["id"] as? Int,
            let name = json["name"] as? String,
            let status = json["status"] as? String,
            let species = json["species"] as? String,
            let type = json["type"] as? String,
            let gender = json["gender"] as? String,
            let origin = json["origin"] as? [String:String],
            let location = json["location"] as? [String:String],
            let imageUrl = json["image"] as? String,
            let episodeAppeared = json["episode"] as? [String],
            let url = json["url"] as? String,
            let created = json["created"] as? String
            else {
                return nil
        }
        self.id = id
        self.name = name
        switch status {
        case "Alive":
            self.status = .alive
        case "Dead":
            self.status = .dead
        default:
            self.status = .dead
        }
        self.species = species
        self.type = type
        switch gender {
        case "Male":
            self.gender = .male
        case "Female":
            self.gender = .female
        default:
            self.gender = .unknown
        }
        self.origin = origin
        self.location = location
        self.imageUrl = imageUrl
        self.episodeAppeared = episodeAppeared
        self.url = url
        self.created = created
        
    }
    
}
