//
//  MALViewController.swift
//  RXSwift
//
//  Created by Lugalu on 22/01/23.
//

import UIKit
import RxSwift
import RxCocoa

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
        
        carrousel.backgroundColor = .red
        viewModel.animes.bind(to: carrousel.rx.items(cellIdentifier: "CarrouselCell", cellType: MALCollectionViewCell.self)){ indexPath, title, cell in
            
            cell.image = UIImage(systemName: "pencil")
            
        }.disposed(by: viewModel.disposeBag)
        
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


