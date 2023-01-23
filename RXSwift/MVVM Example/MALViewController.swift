//
//  MALViewController.swift
//  RXSwift
//
//  Created by Lugalu on 22/01/23.
//

import UIKit

class MALViewController: UIViewController {
    let viewModel: MALViewModel
    
    let carrousel: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.register(MALCollectionViewCell.self, forCellWithReuseIdentifier: "CarrouselCell")
        
        return collection
    }()
    
    
    init(viewModel: MALViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        carrousel.delegate = self
        carrousel.dataSource = self
        carrousel.backgroundColor = .red
        self.setupViews()
        
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = MALViewModel()
        super.init(coder: coder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}


