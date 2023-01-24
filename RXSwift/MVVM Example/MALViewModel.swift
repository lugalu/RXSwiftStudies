//
//  MALViewModel.swift
//  RXSwift
//
//  Created by Lugalu on 22/01/23.
//

import UIKit
import RxSwift

class MALViewModel{
    private let model: MALModel = MALModel()
    
    var animes: PublishSubject<[String]> = PublishSubject()
    var disposeBag: DisposeBag = DisposeBag()
    
    
}
