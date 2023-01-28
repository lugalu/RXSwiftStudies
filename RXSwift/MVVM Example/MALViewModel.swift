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
    private var cellState: CellState = .simple
    
    var animes: AsyncSubject<[Anime]> = AsyncSubject()
    var disposeBag: DisposeBag = DisposeBag()

    var currentCellState: CellState{
        get {
            return cellState
        }
    }
    
    init() {
        _ = model.getAnimes()
            .subscribe(onSuccess: {[weak self] response in
                self?.animes.onNext(response)
                self?.animes.onCompleted()
                
            }).disposed(by: disposeBag)
    }
    
    func changeCellState(){
        cellState = cellState == .simple ? .complex : .simple
    }
    
}
