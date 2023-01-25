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
    
    var animes: AsyncSubject<[Anime]> = AsyncSubject()
    var disposeBag: DisposeBag = DisposeBag()
    
    init() {
        _ = model.getAnimes()
            .subscribe(onSuccess: {[weak self] response in
                self?.animes.onNext(response)
                self?.animes.onCompleted()
                
            }).disposed(by: disposeBag)
    }
    
    
}
