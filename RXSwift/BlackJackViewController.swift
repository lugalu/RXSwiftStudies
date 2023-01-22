//
//  BlackJackViewController.swift
//  RXSwift
//
//  Created by Lugalu on 19/01/23.
//

import UIKit
import RxSwift

fileprivate var cards: [Int] = {
    var arr: [Int] = []
    
    for _ in 1...4{
        for i in 1...13{
            arr.append(i)
        }
    }
    
   return arr
}()

//BlackJack
class BlackJackViewController: UIViewController {

    let staticLabel: UILabel = {
        let label = UILabel()
        label.text = "Current Value:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let valueLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    let drawButton: UIButton = {
        let button = UIButton()
        button.configuration = .bordered()
        button.configuration?.title = "Draw"
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var disposeBag: DisposeBag = DisposeBag()
    var totalValue: Int = 0
    var publisher: PublishSubject<Int> = PublishSubject()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        publisher.disposed(by: disposeBag)
        addSubview()
        configureConstraints()
        
        let subscription = publisher.subscribe(onNext: { element in
            self.totalValue += element
            self.valueLabel.text = "\(self.totalValue)"
        }, onError: { _ in
            self.valueLabel.text = "You hand exploded"
        }, onCompleted: {
            self.valueLabel.text = "BlackJack"
        })
        
        drawButton.addTarget(self, action: #selector(onButtonClick), for: .touchUpInside)
        
        subscription.disposed(by: disposeBag)
    }
    
    func addSubview(){
        self.view.addSubview(staticLabel)
        self.view.addSubview(valueLabel)
        self.view.addSubview(drawButton)
    }
    
    func configureConstraints(){
        let staticConstraints = [
            staticLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16),
            staticLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ]
        
        NSLayoutConstraint.activate(staticConstraints)
        
        let valuelabelConstraint = [
            valueLabel.topAnchor.constraint(equalTo: staticLabel.bottomAnchor, constant: 16),
            valueLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        
        NSLayoutConstraint.activate(valuelabelConstraint)
        
        let drawConstraint = [
            drawButton.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 16),
            drawButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        NSLayoutConstraint.activate(drawConstraint)
    }
    
    @objc func onButtonClick(){
        let random = Int.random(in: 0..<cards.count)
        let val = cards[random]
        if totalValue + val > 21{
            publisher.onError(Errors.exploded)
        }else{
            publisher.onNext(val)
        }
    }

    
    enum Errors: Error{
        case exploded
    }
}



