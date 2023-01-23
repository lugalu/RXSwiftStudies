//
//  MALViewController + Delegate Data Source.swift
//  RXSwift
//
//  Created by Lugalu on 22/01/23.
//

import UIKit

extension MALViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarrouselCell", for: indexPath) as! MALCollectionViewCell
        cell.image = UIImage(systemName: "pencil")
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}
