//
//  MALCollectionViewCollectionViewCell.swift
//  RXSwift
//
//  Created by Lugalu on 22/01/23.
//

import UIKit

class MALCollectionViewCell: UICollectionViewCell {
    var image: UIImage?

    override func prepareForReuse() {
        image = nil
        super.prepareForReuse()
    }
    
    
}
