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
        layout.itemSize = CGSize(width: 205, height: 285)
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
  
        self.addSubscribers()
        
        self.setupViews()
    }
    
    func addSubscribers(){
        viewModel.animes.bind(to: carrousel.rx.items(cellIdentifier: "CarrouselCell", cellType: MALCollectionViewCell.self)){ indexPath, anime, cell in

            cell.configure(withAnime: anime, state: self.viewModel.currentCellState)
            
        }.disposed(by: viewModel.disposeBag)
        
        
        let tap = UITapGestureRecognizer()
        
        tap.rx.event.bind(onNext: {[weak self] event in
            guard let self else {return}
            self.viewModel.changeCellState()
            self.carrousel.reloadData()
        })
        .disposed(by: viewModel.disposeBag)
        
        carrousel.addGestureRecognizer(tap)
        
        colorSwitch.rx.isOn.subscribe{ [weak self] observer in
            guard let self else { return }
            
            let color = (observer.element ?? true) ?  .tertiarySystemBackground : UIColor.systemBackground
            self.view.backgroundColor = color
            self.carrousel.backgroundColor = color
        }.disposed(by: viewModel.disposeBag)
    }
    
    
    
    required init?(coder: NSCoder) {
        self.viewModel = MALViewModel()
        super.init(coder: coder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}


