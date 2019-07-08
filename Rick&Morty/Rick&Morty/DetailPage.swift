//
//  DetailPage.swift
//  Rick&Morty
//
//  Created by Dsilva on 07/07/19.
//  Copyright © 2019 Dsilva. All rights reserved.
//

import UIKit

class DetailPage: UIViewController {
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var characterCollection: UICollectionView!
    
    var episode:EpisodeModel?
    var deadArray = [CharacterModel]()
    var aliveArray = [CharacterModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        getCharacters()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let alert = UIAlertController(title: "Info", message: "Click on the character to kill", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func getCharacters() {
        for character in self.episode!.characters {
            APIHelper.shared.getCharacterWithURL(character) { (characterModel) in
                APIHelper.shared.getImageWithURL(characterModel.url, completion: { (image) in
                    self.splitCharactersInDOA(characterModel)
                })
                if (characterModel.url == self.episode?.characters.last) {
                    DispatchQueue.main.async {
                        self.spinner.stopAnimating()
                    }
                }
            }
        }
    }
    
    func setupUI() {
        self.title = "Characters in \(episode!.episode)"
        self.characterCollection.delegate = self
        self.characterCollection.dataSource = self
        self.spinner.hidesWhenStopped = true
        self.spinner.startAnimating()
    }
    
    func splitCharactersInDOA(_ character:CharacterModel){
            if character.status == .alive {
                self.aliveArray.append(character)
            }else {
                self.deadArray.append(character)
            }
            DispatchQueue.main.async {
                self.characterCollection.reloadData()
            }
    }
    
    
}

extension DetailPage: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2 
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return aliveArray.count
        }else {
            return deadArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: RM_CELL_IDS.SECTION_HEADER, for: indexPath) as? SectionHeaderView {
            sectionHeader.sectionTitle.text = indexPath.section == 0 ? "Alive": "Dead"
            sectionHeader.sectionTitle.textColor = indexPath.section == 0 ? UIColor.green : UIColor.red
            return sectionHeader
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RM_CELL_IDS.EPISODE_CELL, for: indexPath) as! EpisodeCell
        
        var character: CharacterModel?
        if indexPath.section == 0 {
            character = self.aliveArray[indexPath.row]
            cell.xImage.isHidden = true
            cell.deadLabel.isHidden = true
        }else {
            character = self.deadArray[indexPath.row]
            cell.xImage.isHidden = false
            cell.deadLabel.isHidden = false
        }
        
        cell.nameLabel.text = character?.name
        cell.seasonLabel.text = self.episode?.episode
        
        APIHelper.shared.getImageWithURL(character!.url) { (image) in
            cell.episodeImage.image = image
        }
        
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            var character = self.aliveArray[indexPath.row]
            let alert = UIAlertController(title: "Kill \(character.name)", message: "Are you sure you want to kill \(character.name)", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Yes 🔪", style: .default, handler: { action in
                character.status = .dead
                self.deadArray.append(character)
                self.aliveArray.remove(at: indexPath.row)
                for chara in APIHelper.shared.characterArr {
                    if chara.url == character.url {
                        chara.status = .dead
                    }
                }
                self.characterCollection.reloadData()
                
            }))
            alert.addAction(UIAlertAction(title: "NO", style: .default, handler: { action in
                
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    
}
