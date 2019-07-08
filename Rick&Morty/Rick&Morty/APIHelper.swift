//
//  APIHelper.swift
//  Rick&Morty
//
//  Created by Dsilva on 04/07/19.
//  Copyright © 2019 Dsilva. All rights reserved.
//

import UIKit

class APIHelper: NSObject {
    
    // This class keeps track of the page and fetching logic and only gives the filtered, "ONLY data" to the ViewModelClass class
    
    // Statefull
    override init() {}
    static let shared = APIHelper()
    var episodeArr = [EpisodeModel]()
    var characterArr = [CharacterModel]()
    var imageCache = NSCache<NSString, UIImage>()
    var nextPageURL = ""
    
    func getAllEpisodesWith(_ isNextPage: Bool, completion: @escaping (_ episodeArray:[EpisodeModel]) -> () )  {
        
        if  isNextPage == true && nextPageURL == "" {
            return
        }
        
        let allEppisodeURL = isNextPage == true ? nextPageURL : "https://rickandmortyapi.com/api/episode/"
        self.getAPIWith(allEppisodeURL) { (data, error) in
            if self.handleError(data, error: error) {
                
            }else {
                // Parse responce
                do {
                    guard let responce = data else {
                        print("No data present")
                        return
                    }
                    if let responceJSON = try JSONSerialization.jsonObject(with: responce, options: []) as? [String: Any] {
                        
                        guard let infoJSON = responceJSON["info"] as? [String : Any] else {
                            print("No data present1")
                            return
                        }
                        self.nextPageURL = infoJSON["next"] as! String
                        
                        guard let episodeJSON = responceJSON["results"] as? [[String : Any]] else {
                            print("No data present1")
                            return
                        }
                        for episode in episodeJSON {
                            guard let episodeModel = EpisodeModel(json: episode)else {
                                print("error in creating model Json")
                                return
                            }
                            self.episodeArr.append(episodeModel)
                            
                        }
                        completion(self.episodeArr)
                        // created a Episode Model
                        print("EpisodeModel: \(self.episodeArr.count)")
                    }else {
                        print("error in creating Json array")
                    }
                    
                    
                } catch {
                    // error trying to convert the data to JSON using JSONSerialization.jsonObject
                    print("error in creating Json")
                    return
                }
            }
        }// getAPIWith Ends
        
    }
    
    func getAPIWith(_ url: String, completion: @escaping (_ data:Data?,_ error:Error?) -> () ) {
        
        let url = URL(string: url)!
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let filtereddata = data else {
                completion(data,error)
                return
            }
            print(String(data: filtereddata, encoding: .utf8) ?? "")
            completion(data,error)
        }
        
        task.resume()
    }
    
    
    // Gets image when given the character URL
    func getImageWithURL(_ url:String, completion: @escaping (_ image: UIImage) -> ()) {
        let imageFromCache = self.imageCache.object(forKey: url as NSString)
        if imageFromCache == nil {
            //Get Image URL:
            getCharacterWithURL(url) { (character) in
                // fetch image
                URLSession.shared.dataTask(with: URL(string:character.imageUrl)!) {
                    data, response, error in
                    if let response = data {
                        DispatchQueue.main.async {
                            let imageToCache = UIImage(data: response)
                            self.imageCache.setObject(imageToCache ?? UIImage(named: "defaultImage")!, forKey: character.url as NSString)
                            completion(imageToCache!)
                        }
                    }
                    }.resume()
            }
            
        }else {
            completion(imageFromCache!)
        }
    }
    
    func getCharacterWithURL(_ url:String, completion:@escaping (_ character:CharacterModel) -> () ) {
        for character in characterArr {
            if (url == character.url) {
                // Match Found
                completion(character)
                return
            }
        }
        // means there is no matching char, call for char
        
        self.getAPIWith(url) { (data, error) in
            guard self.handleError(data, error: error) == false else { // true means no error
                
                return
            }
            // Parse responce
            do {
                guard let responce = data else {
                    print("No data present")
                    return
                }
                if let responceJSON = try JSONSerialization.jsonObject(with: responce, options: []) as? [String: Any] {
                    guard let characterModel = CharacterModel.init(json: responceJSON) else{
                        print("error in creating model Json")
                        return
                    }
                    var matchFound = false
                    for character in self.characterArr {
                        if character.imageUrl == characterModel.imageUrl {
                            matchFound = true
                        }
                    }
                    if matchFound == false {
                        self.characterArr.append(characterModel)
                    }
                    completion(characterModel)
                }else {
                    print("error in creating Json array")
                }
            } catch {
                // error trying to convert the data to JSON using JSONSerialization.jsonObject
                print("error in creating Json")
                return
            }
        }
    }
    
    func handleError(_ data: Data?, error: Error? ) -> Bool {
        if let err = error {
            // error occured
            
            return false
        }else {
            return false
        }
    }
    
    
    
}
