//
//  CustomCollectionViewCell.swift
//  CollectionImage
//
//  Created by Vladislav on 3/30/18.
//  Copyright © 2018 Vladislav. All rights reserved.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    func changeActivityIndicator( flag: Bool) -> Bool {
        
        var flag = flag
        if !flag {
            activityIndicator.startAnimating()
            flag = true
        }else{
            activityIndicator.stopAnimating()
            flag = false
        }
        return flag
        
    }
}
