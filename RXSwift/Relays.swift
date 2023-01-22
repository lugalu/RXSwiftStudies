//
//  Relays.swift
//  RXSwift
//
//  Created by Lugalu on 16/01/23.
//

import UIKit
import RxSwift
import RxRelay

func relays(){
    
    //MARK: Publish Relay
    example(of: "PublishRelay") {
        let relay = PublishRelay<String>()

        let disposeBag = DisposeBag()
        
        relay.accept("Knock knock, anyone home?")
        
        relay
          .subscribe(onNext: {
            print($0)
          })
          .disposed(by: disposeBag)

        relay.accept("1")
        
        /* Doesn't work
         relay.accept(MyError.anError)
         relay.onCompleted()
         */

    }
    
    //MARK: Behaviour Relay
    example(of: "BehaviorRelay") {
        let relay = BehaviorRelay(value: "Initial value")
        let disposeBag = DisposeBag()

        relay.accept("New initial value")
        relay
          .subscribe {
            customprint(label: "1)", event: $0)
          }
          .disposed(by: disposeBag)
        
        // 1
        relay.accept("1")

        // 2
        relay
          .subscribe {
            customprint(label: "2)", event: $0)
          }
          .disposed(by: disposeBag)

        // 3
        relay.accept("2")
        
        print(relay.value)
      }
}
