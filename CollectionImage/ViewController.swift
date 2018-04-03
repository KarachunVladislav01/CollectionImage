//
//  ViewController.swift
//  CollectionImage
//
//  Created by Vladislav on 3/30/18.
//  Copyright © 2018 Vladislav. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()
var imageUrlString:String?

extension UIImageView {
    
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {

        imageUrlString = link
        let url = URL(string: link)
        contentMode = mode
        image  = nil
        if let imageFromCache = imageCache.object(forKey: link as AnyObject) as? UIImage{
            self.image = imageFromCache
            return
        }
        URLSession.shared.dataTask(with: url!) { data, response, error in

            if error != nil {
                print(error ?? "error")
                return
            }
            
            
            DispatchQueue.main.async() {
                
                let imageToCache = UIImage(data: data!)
                
                if imageUrlString == link{
                self.image = imageToCache
                }
                
                imageCache.setObject(imageToCache!, forKey: link as AnyObject)
            }
            
            }.resume()
    }
}

struct Hero: Decodable{
    let  localized_name : String
    let img: String
    
}

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    var hero = [Hero]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let url = URL(string: "https://api.opendota.com/api/heroStats")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error == nil {
                do {
                    self.hero = try JSONDecoder().decode([Hero].self, from: data!)
                } catch {
                    print("Parse Error")
                }
                DispatchQueue.main.async {
                    
                    self.collectionView.reloadData()
                    print(self.hero.count)
                }
                
            }
        }.resume()
       
        // Do any additional setup after loading the view, typically from a nib.
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hero.count
    }
    
//http://ddragon.leagueoflegends.com/cdn/6.24.1/img/champion/MonkeyKing.png
//http://ddragon.leagueoflegends.com/cdn/img/champion/splash/MonkeyKing_1.jpg
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CustomCollectionViewCell
        cell.imageView.contentMode = .scaleAspectFit
        
        let link = "https://api.opendota.com" + hero[indexPath.row].img
        
        cell.imageView.downloadedFrom(link: link)
        return cell
    }


}

