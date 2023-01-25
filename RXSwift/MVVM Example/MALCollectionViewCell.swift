//
//  MALCollectionViewCollectionViewCell.swift
//  RXSwift
//
//  Created by Lugalu on 22/01/23.
//

import UIKit

class MALCollectionViewCell: UICollectionViewCell {
    private var imageView = UIImageView()

    
    
    func configure(withImage image: UIImage?){
        self.imageView.image = image
        self.imageView.contentMode = .scaleAspectFill
        self.imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        setupView()
    }
    
    func setupView(){
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imageView)
        
        let constraints = [
            imageView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor),
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
