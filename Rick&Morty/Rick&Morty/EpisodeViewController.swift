//
//  EpisodeViewController.swift
//  Rick&Morty
//
//  Created by Dsilva on 03/07/19.
//  Copyright © 2019 Dsilva. All rights reserved.
//

import UIKit

class EpisodeViewController: UIViewController {
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var episodeCollection: UICollectionView!
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    var downloadTracker = [String:Bool]()
    var episodeArr = [EpisodeModel]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        getEpisodes()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let episode = sender as? EpisodeModel else {
            return
        }
        let detailScreen = segue.destination as! DetailPage
        detailScreen.episode = episode
    }
    
    func setupUI(){
        self.title = "Rick and Morty"
        self.episodeCollection.dataSource = self
        self.episodeCollection.delegate = self
        self.spinner.hidesWhenStopped = true
        self.spinner.startAnimating()
    }
    
    fileprivate func getEpisodes() {
        // next page is false coz we are calling for initial load
        APIHelper.shared.getAllEpisodesWith(false) { (episodeArray) in
            if episodeArray.count != 0 {
                self.episodeArr = episodeArray
                DispatchQueue.main.async {
                    self.spinner.stopAnimating()
                    self.episodeCollection.reloadData()
                }
            }
        }
    }
}

extension EpisodeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 10
        let collectionViewWidth = screenWidth - padding
        
        return CGSize(width: collectionViewWidth/2, height: collectionViewWidth/(2*0.82))
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return episodeArr.count // temp
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RM_CELL_IDS.EPISODE_CELL, for: indexPath) as! EpisodeCell
        
        let episode = self.episodeArr[indexPath.row]
        cell.nameLabel.text = episode.name
        cell.seasonLabel.text = episode.episode
        cell.episodeImage.image = UIImage(named: "defaultImage")
        cell.episodeImage.animationImages?.removeAll()
        if self.downloadTracker[episode.url] == true {
            for character in episode.characters {
                APIHelper.shared.getImageWithURL(character) { (image) in
                    cell.episodeImage.animationImages?.append(image)
                    cell.episodeImage.animationDuration = 15
                    cell.episodeImage.animationRepeatCount = 100
                    cell.episodeImage.startAnimating()
                }
            }
        }
        
        
        if indexPath.row == self.episodeArr.count - 2 {
            APIHelper.shared.getAllEpisodesWith(true) { (episodeArray) in
                if (episodeArray.count > 0) {
                    DispatchQueue.main.async {
                        self.episodeArr = episodeArray
                        self.episodeCollection.reloadData()
                    }
                }
                
            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: RMSegues.SEGUE_EPISODE_TO_DETAIL_PAGE, sender: self.episodeArr[indexPath.row])
    }
    
    
}
