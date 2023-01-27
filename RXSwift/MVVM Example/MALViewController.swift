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
        
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 225, height: 320)
        layout.minimumLineSpacing = 16
        layout.headerReferenceSize = CGSize(width: 50, height: 16)
        layout.footerReferenceSize = CGSize(width: 50, height: 16)
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collection.translatesAutoresizingMaskIntoConstraints = false
        
        collection.register(MALCollectionViewCell.self, forCellWithReuseIdentifier: "CarrouselCell")
        
        return collection
    }()
    
    let switchLabel: UILabel = {
        let label = UILabel()
        label.text = "Switch Color"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let colorSwitch: UISwitch = {
        let uiSwitch = UISwitch()
        uiSwitch.translatesAutoresizingMaskIntoConstraints = false
        return uiSwitch
    }()
    
    
    init(viewModel: MALViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
  
        viewModel.animes.bind(to: carrousel.rx.items(cellIdentifier: "CarrouselCell", cellType: MALCollectionViewCell.self)){ indexPath, anime, cell in

            cell.configure(withImage: anime.image)
            
        }.disposed(by: viewModel.disposeBag)
        
        colorSwitch.rx.isOn.subscribe{ [weak self] observer in
            guard let self else { return }
            
            let color = (observer.element ?? true) ?  .tertiarySystemBackground : UIColor.systemBackground
            self.view.backgroundColor = color
            self.carrousel.backgroundColor = color
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


