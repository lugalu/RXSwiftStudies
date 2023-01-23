//
//  MALViewController + Constraints.swift
//  RXSwift
//
//  Created by Lugalu on 22/01/23.
//

import UIKit

extension MALViewController{
    
    func setupViews() {
        addSubviews()
        addConstraints()
    }
    
    private func addSubviews() {
        view.addSubview(carrousel)
    }
    
    private func addConstraints() {
        addCarrouselConstraints()
    }
    
    private func addCarrouselConstraints(){
        let constraints = [
            carrousel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            carrousel.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            carrousel.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            carrousel.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    
}
