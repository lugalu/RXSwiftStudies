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
        view.addSubview(switchLabel)
        view.addSubview(colorSwitch)
    }
    
    private func addConstraints() {
        addCarrouselConstraints()
        addColorLabelConstraints()
        addColorSwitchConstraints()
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
    
    private func addColorLabelConstraints(){
        let constraints = [
            switchLabel.topAnchor.constraint(equalTo: carrousel.bottomAnchor),
            switchLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant:  16)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func addColorSwitchConstraints(){
        let constraints = [
            colorSwitch.topAnchor.constraint(equalTo: carrousel.bottomAnchor),
            colorSwitch.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant:  -16)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    
}
