//
//  MALCollectionViewCollectionViewCell.swift
//  RXSwift
//
//  Created by Lugalu on 22/01/23.
//

import UIKit

enum CellState {
    case simple
    case complex
}

class MALCollectionViewCell: UICollectionViewCell {
    private var imageView: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFill
        imgView.layer.cornerRadius = 10
        imgView.layer.masksToBounds = true
        
        return imgView
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let favoriteCounter: FavoriteCounter = {
        let counter = FavoriteCounter(frame: CGRect(x: 0, y: 0, width: 50, height: 32))
        counter.translatesAutoresizingMaskIntoConstraints = false
        
        
        return counter
    }()
    
    
    func configure(withAnime anime: Anime?, state currentState: CellState){
        addData(animeData: anime)
        
        setupImageView()
        
        switch currentState{
        case .simple:
            setupSimpleCell()
        case .complex:
            setupComplexCell()
        }
    }
 
    private func addData(animeData data: Anime?){
        let text = (3...12).contains(data?.title.count ?? 5) ? data?.title: (3...12).contains(data?.abbreviatedTitle?.count ?? 5) ? data?.abbreviatedTitle : "Title is too big"
        
        imageView.image = data?.image
        titleLabel.text = text
        favoriteCounter.configure(withCount: data?.favoriteCount)
    }
    
    
    private func setupSimpleCell(){
        removeSubviews()
    }
    
    private func setupComplexCell(){
        addSubviews()
        addTitleLabelConstraints()
        addFavoriteCounterConstraints()
    }
    
    private func addSubviews(){
        self.addSubview(titleLabel)
        self.addSubview(favoriteCounter)
    }
    
    private func removeSubviews(){
        self.titleLabel.removeFromSuperview()
        self.favoriteCounter.removeFromSuperview()
        NSLayoutConstraint.deactivate(favoriteCounter.constraints)
    }
    
    private func addTitleLabelConstraints(){
        let constraints = [
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 24),
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    private func addFavoriteCounterConstraints(){
        let size = favoriteCounter.getContentSize()
        let constraints = [
            favoriteCounter.widthAnchor.constraint(equalToConstant: size.width),
            favoriteCounter.heightAnchor.constraint(equalToConstant: size.height),
            favoriteCounter.topAnchor.constraint(equalTo: self.topAnchor),
            favoriteCounter.rightAnchor.constraint(equalTo: self.rightAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupImageView(){
        self.addSubview(imageView)
        
        let constraints = [
            imageView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor),
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    
    override func prepareForReuse() {
        self.removeSubviews()
        super.prepareForReuse()
    }
}


fileprivate class FavoriteCounter: UIView{
    
    let star: UIImageView = {
        let img = UIImageView(image: UIImage(systemName: "star.fill"))
        img.tintColor = .systemYellow
        img.contentMode = .scaleAspectFit
        img.translatesAutoresizingMaskIntoConstraints = false
        
        return img
    }()
    
    private var countLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    func configure(withCount text: Int?){
        self.backgroundColor = .black
        self.layer.opacity = 0.75
        self.layer.maskedCorners = CACornerMask(arrayLiteral: [.layerMaxXMinYCorner, .layerMinXMaxYCorner])
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        
        countLabel.text = "\(text ?? 0)"
        
        self.addSubview(star)
        self.addSubview(countLabel)
        
        let starConstraints = [
            star.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 4),
            star.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ]
        
        let countConstraints = [
            countLabel.leftAnchor.constraint(equalTo: star.rightAnchor, constant: 4),
            countLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(starConstraints)
        NSLayoutConstraint.activate(countConstraints)
    }
    
    func getContentSize() -> CGSize{
        star.sizeToFit()
        countLabel.sizeToFit()
        self.sizeToFit()
        
        var size = CGSize(width: 0, height: 0)
        
        size.width = star.frame.width + countLabel.frame.width + 15
        size.height = 32
        
        return size
    }
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
        star.removeFromSuperview()
        countLabel.removeFromSuperview()
    }
    
    
}
