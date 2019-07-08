//
//  EpisodeModel.swift
//  Rick&Morty
//
//  Created by Dsilva on 05/07/19.
//  Copyright © 2019 Dsilva. All rights reserved.
//

import UIKit

class EpisodeModel: NSObject {

    var id: Int
    var name: String
    var airDate: String
    var episode: String
    var characters: [String]
    var url: String
    var created:  String
    
    init(id: Int, name: String, airDate: String, episode: String, characters: [String], url: String, created: String) {
        self.id = id
        self.name = name
        self.airDate = airDate
        self.episode = episode
        self.characters = characters
        self.url = url
        self.created = created
    }
    
    init?(json: [String: Any]) {
        
        guard let id = json["id"] as? Int,
            let name = json["name"] as? String,
            let airDate = json["air_date"] as? String,
            let episode = json["episode"] as? String,
            let characters = json["characters"] as? [String],
            let url = json["url"] as? String,
            let created = json["created"] as? String
        else {
                return nil
        }
        self.id = id
        self.name = name
        self.airDate = airDate
        self.episode = episode
        self.characters = characters
        self.url = url
        self.created = created
        
    }

}
